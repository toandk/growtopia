# 1: gapo_flutter branch
# 2: gp_feat_album branch
# 3: gp_feat_calendar branch
# 4: gp_feat_member_picker branch
# 5: gp_feat_task branch

flutterDefaultBranch="develop"

cd ../../gapo_flutter/

currentPWD=$PWD

echo "currentPWD: $currentPWD"

echo "1---$1"
echo "2---$2"
echo "3---$3"
echo "4---$4"
echo "5---$5"

if [ -z "$1" ] || [ "$1" = "null" ];
then
    branchName=$flutterDefaultBranch
else
    branchName=$1
fi

if [ -z "$2" ] || [ "$2" = "null" ];
then
    albumBranch=$flutterDefaultBranch
else
    albumBranch=$2
fi

if [ -z "$3" ] || [ "$3" = "null" ];
then
    calendarBranch=$flutterDefaultBranch
else
    calendarBranch=$3
fi

if [ -z "$4" ] || [ "$4" = "null" ];
then
    mPickerBranch=$flutterDefaultBranch
else
    mPickerBranch=$4
fi

if [ -z "$5" ] || [ "$5" = "null" ];
then
    taskBranch=$flutterDefaultBranch
else
    taskBranch=$5
fi

echo '----------prepare branch:---------'
echo "----------calendar branch is: $calendarBranch---------"
echo "----------task branch is: $taskBranch---------"
echo "----------member picker branch is: $mPickerBranch---------"

git add .
git stash save "Local"

git submodule foreach 'git add .'
git submodule foreach 'git stash save "Local" || :'

git fetch origin
git switch $branchName
# git pull origin $branchName
git reset --hard origin/$branchName

# mặc định switch về develop, sau đó mói switch qua các branch khác phòng trường hợp branch chưa tồn tại
# vd ở album dùng branch develop cho tất cả
git submodule foreach "git fetch origin || :"
git submodule foreach "git switch develop || :"
# git submodule foreach "git pull origin develop || :"
git submodule foreach "git reset --hard origin/develop || :"

if [ "$branchName" != "$flutterDefaultBranch" ];
then
git submodule foreach "git switch $branchName || :"
git submodule foreach "git pull origin $branchName || :"
fi

if [ "$albumBranch" != "$flutterDefaultBranch" ];
then
cd app/features/album
git switch $albumBranch
git pull origin $albumBranch
fi

cd $currentPWD

if [ "$calendarBranch" != "$flutterDefaultBranch" ];
then
cd app/features/calendar
git switch $calendarBranch
git pull origin $calendarBranch
fi

cd $currentPWD

if [ "$mPickerBranch" != "$flutterDefaultBranch" ];
then
cd app/features/member_picker
git switch $mPickerBranch
git pull origin $mPickerBranch
fi

cd $currentPWD

if [ "$taskBranch" != "$flutterDefaultBranch" ];
then
cd app/features/task
git switch $taskBranch
git pull origin $taskBranch
fi

cd $currentPWD

dart pub global activate melos 2.9.0

source ~/.zshrc

melos clean
melos bs

clear