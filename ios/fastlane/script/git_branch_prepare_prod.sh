flutterDefaultBranch="prod"

cd ../../gapo_flutter/

currentPWD=$PWD

echo "currentPWD: $currentPWD"

echo "1---$1"

# chỉ nhận duy nhất prod, hoặc 1 target branch cụ thể (ví dụ tag)
# e.g: `fastlane production flutterbranch: 3.2.1`

if [ -z "$1" ] || [ "$1" = "null" ];
then
    branchName=$flutterDefaultBranch
else
    branchName=$1 # targetBranch
fi

echo '----------prepare branch:---------'
echo "----------branchName is: $branchName---------"

git add .
git stash save "Local before build $branchName"

# delete old branch
git checkout develop
git branch -D $branchName

#git submodule foreach 'git add .'
#git submodule foreach 'git stash save "Local" || :'

git fetch origin

git checkout $branchName
# git pull origin $branchName
git reset --hard origin/$branchName

sh script/git/remove_pubspec_overrides.sh

cd app/
echo "PWD: $PWD"

# save stash cho chắc cốp, thử xem có còn bị dính lỗi `flutter_application_path` không
git submodule foreach 'git add .'
git submodule foreach "git stash save 'Local before build $branchName' || :"

# flutter pub get, lấy toàn bộ code từ git về, bỏ qua code ở local modules
flutter clean
flutter pub get

clear