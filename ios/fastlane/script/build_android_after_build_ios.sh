cd ../../gapo_flutter

sh script/android-pre-build.sh

flutter build aar

cp -rf /build/host/outputs/repo/* ../gapowork_android/app/aar-center

cd ../gapowork_android/app

# fetch main
git status
git reset --h
git fetch
git checkout build/flutter
git pull origin build/flutter
git pull origin feature/ep3/calendar
git pull origin develop

# fetch aar-center
cd aar-center
git reset --h
git pull
cd ../

# fetch flutters
cd flutterx
git reset --h
git pull
cd ../

cd fastlane

### build and upload to telegram
# fastlane android stagingDebug
# fastlane android productionDebug

fastlane android stagingDebug ios_version:$@
