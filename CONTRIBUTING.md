# Contributing

If you wish to contribute then please first open an issue to discuss the need.  
As the intended purposes are limited, I may not be able to merge your request.

This repository consist of dev (HEAD), stag, prod branches.  
You should raise the PR on the dev branch.  
Refer [`.github/workflows/ci-contributors.yml`] to know more.


## Prerequisites

Based on your interest, you might have to run one of the below.  
Refer [`./tool/prerequisite.sh`] script.  
Not all packages are required to run the project.

1. Minimal  
   For those who just wish to run this project.
   ```console
   ./tool/prerequisite.sh --minimal
   ```

2. Contributors  
   For those who wish to contribute to this project.
   ```console
   ./tool/prerequisite.sh --contributor
   ```

3. Members  
   For active members of this project.
   ```console
   ./tool/prerequisite.sh --member
   ```


## CI

Refer [`./tool/ci.sh`] script to start building this project.


## Release Notes

Following are the release related files:
- [`pubspec.yaml`]
- [`lib/constants/constants.dart`]
- [`CHANGELOG.md`]
- [`android/fastlane/prod/metadata/android/en-US/changelogs/default.txt`]
- [`ios/fastlane/prod/metadata/en-US/release_notes.txt`]

## Screenshot Notes

### iOS

Docs: 
- https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications

Screen Size Inches | Screen Size Aspect Ratio | Recently Used                                       | Previously Used                      
---                | ---                      | ---                                                 | ---                                  
6.7                | 19.5:9                   | iPhone 15 Pro Max                                   |                                      
5.5                | 16:9                     | iPhone SE (3rd generation) resized<sup>1</sup>      | iPhone 8 Plus                        
13                 | 4:3                      | ~~iPad Pro 13-inch (M4)~~<sup>2</sup> iPad Air (M2) | iPad Pro (12.9-inch) (6th generation)
12.9               | 10:7                     | iPad Pro 11-inch (M4) resized<sup>1</sup>           | iPad Pro (12.9-inch) (2nd generation)

1. Resized to Previously Used screen resolutions  
   See: [`tool/ios/resize-obsolete-devices-screenshots.sh`]
2. iPad Pro 13-inch (M4) screen resolution not yet added in fastlane (https://github.com/fastlane/fastlane/issues/22030)

[`.github/workflows/ci-contributors.yml`]: .github/workflows/ci-contributors.yml
[`./tool/prerequisite.sh`]: ./tool/prerequisite.sh
[`./tool/ci.sh`]: ./tool/ci.sh
[`pubspec.yaml`]: pubspec.yaml
[`lib/constants/constants.dart`]: lib/constants/constants.dart
[`CHANGELOG.md`]: CHANGELOG.md
[`android/fastlane/prod/metadata/android/en-US/changelogs/default.txt`]: android/fastlane/prod/metadata/android/en-US/changelogs/default.txt
[`ios/fastlane/prod/metadata/en-US/release_notes.txt`]: ios/fastlane/prod/metadata/en-US/release_notes.txt
[`tool/ios/resize-obsolete-devices-screenshots.sh`]: tool/ios/resize-obsolete-devices-screenshots.sh
