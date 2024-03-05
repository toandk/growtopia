cd ../../gapo_flutter/
git reset --h
git fetch
git checkout staging
git pull origin staging

flutter clean
flutter pub get

clear
