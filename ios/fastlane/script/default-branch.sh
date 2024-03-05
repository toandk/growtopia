cd ../../gapo_flutter/
git reset --h
git fetch
git checkout release
git pull origin release

flutter clean
flutter pub get

clear
