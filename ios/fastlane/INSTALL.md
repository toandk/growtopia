# Project Schemes

Project has 3 schemes: `GAPO` `Staging-adhoc` `Staging-Testflight`

- `GAPO` scheme run in **DEBUG mode** (CMD + R) is for testing production environment
- `GAPO` scheme archive is for upload production ipa
- `Staging-adhoc` and `Staging-Testflight` run in **DEBUG mode** (CMD + R) is for testing staging environment
- `Staging-adhoc` archive is for uploading staging build to Diawi
- `Staging-Testflight` archive is for uploading staging build to Testflight

# Installation

Create a new file `fastlane/.env` with the following content:

```
APPLE_ID=<YOUR_APPLE_ID>
FASTLANE_USER=<YOUR_APPLE_ID>
FASTLANE_PASSWORD=<YOUR_APPLE_ID_PASSWORD>
```

Note: This file is stored in your local and doesn't be pushed to remote.

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

- Install _fastlane_ using

```
[sudo] gem install fastlane -NV
```

or alternatively using `brew cask install fastlane`

- Install Bundler

```
gem install bundler
```

```
bundle install
```

- Install fastlane plugins

```
fastlane install_plugins
```

- Setup Fastlane username:

```
fastlane fastlane-credentials add --username <YOUR_APPLE_ID>
```

Then enter your password to save your credentials to keychain

# Build for testing

- Build and upload staging ipa to Testflight

```
bundle exec fastlane staging_testflight build_number:xxx
```

Note that `build_number:xxx` is optional, if you skip it, it will auto increase the build number, base on current latest build number on Testflight

- Build and upload staging ipa to Diawi

```
bundle exec fastlane staging_adhoc build_number:xxx
```

- Build production to submit to Apple review:

```
bundle exec fastlane release
```

# Flutter options
### rsflutter
- To reset flutter branch to default branch like staging, production, release
- e.g. fastlane staging will reset flutter repo branch to staging
- If don't want to reset to default branch, set `rsflutter:false`
- Default value is `true`

### flutterchangelog
- To show flutter change log on release notes
- Default value is `false`

### flutterbranch
- Branch to be displayed on release notes
- Default value is `false`

### example of flutter options
```
fastlane staging rsflutter:false flutterchangelog:true flutterbranch:feature/minitask-detail-to-task-list 
```