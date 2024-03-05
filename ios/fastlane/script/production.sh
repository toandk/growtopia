if $1 == "";
then
    branchName="production"
else
    branchName=$1
fi

cd ../../gapo_flutter/
git reset --h
git fetch
git checkout $branchName
git pull origin $branchName
flutter clean
flutter pub get

clear
