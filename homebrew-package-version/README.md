# Homebrew package version
Script helps you find particular homebrew package version and generate install command. Useful when using `brew switch` command a lot.


## Dependencies
[`brew`](https://brew.sh/index_pl) - package manager

[`direnv`](https://direnv.net/) - optional configuration


## Basic usage
1. Command overview

    ```
    ./hpv.sh [formula] [version]
    ```

1. Simple usage
    ```
    ./hpv.sh
    ```
    will ask for formula
    ```
    Formula: [provide formula here]
    ```
    then ask for version
    ```
    Version [skip for all): [provide package version or enter to skip]
    ```
1. Find `kops` package versions

    ```
    ./hpv.sh kops
    ```
    will produce
    ```
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/0a5017af6c6bae3b188a79230ed8882316edb344/Formula/kops.rb for version 1.10.0
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/7bb0783bb5981449cbcb2f0aeba364af28225816/Formula/kops.rb for version 1.10.0
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/5f179917ac8aa2e4b6854c96fff2a6fa68623690/Formula/kops.rb for version 1.9.2
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/554ab7b24a96a755c4b17a58428c423ddab5944b/Formula/kops.rb for version 1.9.1
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/376605b56393496731066ad842c36b564cc87299/Formula/kops.rb for version 1.9.0
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/e114a5abf3c5d930207def1024562d14e95b79d6/Formula/kops.rb for version 1.8.1
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/c7cb592be62b3935ba69bae1f21a45834acb28d9/Formula/kops.rb for version 1.8.0
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/33a3e800eaa3d3f6e503ca438304370b808a2137/Formula/kops.rb for version 1.7.1
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/51b66d8edbe697eb03e2b39447cab64513b5196c/Formula/kops.rb for version 1.7.1
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/ea898ba8e7dcffd88500a0a85738d19cf452e52c/Formula/kops.rb for version 1.7.0
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/9133fcc52bb46fcf425899ac194ff11d7a33c211/Formula/kops.rb for version 1.7.0
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/af6301f13f40df302ec417e9669631e604460a6d/Formula/kops.rb for version 1.6.2
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/fdb4b0f45776a7179d2994cbae4d9d978a0307ce/Formula/kops.rb for version 1.6.1
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/e4c18c58801157733983c3454194ddda4f19280e/Formula/kops.rb for version 1.6.0
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/2895ffe6c041b8c1c081c0eb63266e77fa96403c/Formula/kops.rb for version 1.5.3
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/c0aedfd35ab664c7b8048269576fe170698e4210/Formula/kops.rb for version 1.5.1
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/01ee3735f48940e2753819aa4680f955270edbfa/Formula/kops.rb for version 1.4.4
    ```
1. Find `kubernetes-cli` package in `1.9` versions
    ```
    ./hpv.sh kubernetes-cli 1.9
    ```
    will produce
    ```
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/505fcec7a3cf4f1a073b45bc7ae8294649a33f89/Formula/kubernetes-cli.rb for version 1.9.6
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/fb2b8854da6a92000f3d9b1a933b816565a632d9/Formula/kubernetes-cli.rb for version 1.9.5
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/505113a12c814d24f38ee058b36a09de5e7bcb85/Formula/kubernetes-cli.rb for version 1.9.4
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/46b2d6d52e7f922be340c2173da2b8d56f70c778/Formula/kubernetes-cli.rb for version 1.9.3
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/1d6446a1db65f375e5ed0e12539b825708ee1d84/Formula/kubernetes-cli.rb for version 1.9.2
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/f35eb4707eed0f6b47818dd5d8a28908eb57d26d/Formula/kubernetes-cli.rb for version 1.9.1
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/cabdf9ab1347e5c6ccddbe6d783c57d44934aad4/Formula/kubernetes-cli.rb for version 1.9.0
    ```

## Basic configuration

You can adjust following parameters

* HPV_SOURCE - homebrew package version source directory -> `hpv.sh` path (default: `$PWD`)
* HPV_HOMEBREW_REPO_DIR - homebrew-core repository path (default: `$HPV_SOURCE/.homebrew-core`)
* HPV_CACHED_LOGS_DIR - cached git log directory (default: `$HPV_SOURCE/.cached-logs`)
* HPV_PULL_INTERVAL - how often homebrew-core repository should be checked for updates (default: `3600 seconds`)

When execute command locally (`./hpv` [`package`] [`version`]) default values are fine

## Global configuration
To enable global use of `hpv` command:
* create symlink in `/usr/local/bin` directory
    ```
    ln -s [YOUR_PATH]/hpv.sh /usr/local/bin/hpv
    ```
* set HPV_SOURCE env variable
    ```
    HPV_SOURCE=[YOUR_PATH]/homebrew-package-version
    ```

## Autocomplete configuration
#### ZSH
1. Copy `./completion/zsh/_hpv` file to  `~/.zsh/completion/_hpv`
1. Put following configuration into `~/.zshrc`
```
fpath=(~/.zsh/completion $fpath)
# compsys initialization
autoload -U compinit
compinit

# show completion menu when number of options is at least 2
zstyle ":completion:*:descriptions" format "%B%d%b"
zstyle ':completion:*' menu select=2

# GLOBAL HPV CONFIGURATION
export HPV_SOURCE=[YOUR_PATH]/homebrew-package-version

# HPV AUTOCOMPLETE CONFIGURATION
export HPV_HOMEBREW_REPO_DIR=$HPV_SOURCE/.homebrew-core
export HPV_CACHED_LOGS_DIR=$HPV_SOURCE/.cached-logs
```
## How does it work?

1. Checks if `homebrew-core` repository exists, if not it will be cloned into configured by `HPV_HOMEBREW_REPO_DIR` param directory (default `$HPV_SOURCE/.homebrew-core`)
1. Check if formula exists in brew (`brew info [formula]`)
1. Analyzing given formula `git log`s
1. Create logs cache for the package you are looking for in `HPV_CACHED_LOGS_DIR` (default `$HPV_SOURCE/.cached-logs`)
1. Show formula versions with installation links

## Additional features
1. `Git pull` command will be performed depending on `HPV_PULL_INTERVAL` parameter (default `3600 seconds`)
1. Cache files are invalidate every time the formula changes in the repository
1. Shows the time until the next `git pull` occurs
1. Package and version autocompletion mechanism