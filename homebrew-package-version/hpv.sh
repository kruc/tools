#!/bin/bash
# Default config
HPV_SOURCE=${HPV_SOURCE:-$PWD}
HPV_HOMEBREW_REPO_DIR=${HPV_HOMEBREW_REPO_DIR:-$HPV_SOURCE/.homebrew-core}
HPV_CACHED_LOGS_DIR=${HPV_CACHED_LOGS_DIR:-$HPV_SOURCE/.cached-logs}
HPV_PULL_INTERVAL=${HPV_PULL_INTERVAL:-3600}

# Internal variable
CURRENT_TIMESTAMP=$(date +%s)
PULL_LOG_FILE=$HPV_SOURCE/.pull-log-file

if [ ! -f $PULL_LOG_FILE ]; then
	echo $CURRENT_TIMESTAMP >$PULL_LOG_FILE
fi

# Read required formula parameter
if [ -z ${1} ]; then
	read -p "Formula: " HPV_FORMULA
	while [ -z ${HPV_FORMULA} ]; do
		read -p "Formula: " HPV_FORMULA
	done
else

	HPV_FORMULA=$1
fi

HPV_FILE=$HPV_FORMULA

# HPV_VERSION=${HPV_VERSION:- }
if [ -z ${2} ]; then
	read -p "Version (skip for all): " HPV_VERSION
	HPV_VERSION=${HPV_VERSION:-.+}
else

	HPV_VERSION=${2}
fi

# Check if homebrew-core repository is available under configured path
if [ ! -d "$HPV_HOMEBREW_REPO_DIR/.git" ]; then
	echo "homebrew-core repository not found under $HPV_HOMEBREW_REPO_DIR"
	git clone git@github.com:Homebrew/homebrew-core.git $HPV_HOMEBREW_REPO_DIR
	echo $CURRENT_TIMESTAMP >$PULL_LOG_FILE
else
	# Prevent from git pull on each execute - configured by HPV_PULL_INTERVAL variable
	LAST_PULL_TIMESTAMP=$(awk '/./{line=$0} END{print line}' $PULL_LOG_FILE)
	DIFF=$((CURRENT_TIMESTAMP - LAST_PULL_TIMESTAMP))
	if [ $DIFF -gt $HPV_PULL_INTERVAL ]; then
		echo "Pulling latest changes from homebrew-core repository"
		git -C $HPV_HOMEBREW_REPO_DIR pull origin master &>$PULL_LOG_FILE
		date +%s >>$PULL_LOG_FILE
		# Check if formula was updated since last pull
		UPDATE_CACHE=$(grep -o "Formula/$HPV_FORMULA" $PULL_LOG_FILE)
		if [ ! -z ${UPDATE_CACHE} ]; then
			echo "Remove cache of ${HPV_FILE}"
			rm ${HPV_CACHED_LOGS_DIR}/$HPV_FILE
		fi
	else
		echo "Next git pull in $(((HPV_PULL_INTERVAL - DIFF) / 60)) minutes"
	fi
fi

if [ ! -f "$HPV_CACHED_LOGS_DIR/$HPV_FILE" ]; then

	# Check if formula exists in homebrew repository
	CHECK_FORMULA=$(brew info $HPV_FORMULA 2>&1 1>/dev/null | grep -wE "(Error: No available)")
	if [ ! -z "$CHECK_FORMULA" ]; then
		tput setaf 1
		echo "Error: No available formula with the name $HPV_FILE"
		exit
	fi

	echo "$HPV_FILE not found in cache - analyzing git logs..."
	mkdir -p $HPV_CACHED_LOGS_DIR
	git --git-dir $HPV_HOMEBREW_REPO_DIR/.git log --pretty=tformat:'%H %s' master -- Formula/$HPV_FILE.rb > $HPV_CACHED_LOGS_DIR/$HPV_FILE
fi

tput setaf 2
cat $HPV_CACHED_LOGS_DIR/$HPV_FILE |
	grep -wE "($HPV_FORMULA: update \d+.\d+.\d+ bottle\.$)" |
	sed "s/$HPV_FORMULA:/$HPV_FORMULA/g" |
	awk '{printf "brew unlink %s && brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/%s/Formula/%s.rb for version %s\n", $2, $1, $2, $4}' |
	grep -wE "($HPV_VERSION)"
