export SOURCESAFE_DB=${1}
export SOURCESAFE_SUB_TREE=${2}
export GIT_REPOSITORY_PATH=${3};
export GIT_BRANCH_NAME=$(echo "${SOURCESAFE_DB}_${SOURCESAFE_SUB_TREE}" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\\$");

mkdir -p ${GIT_REPOSITORY_PATH};

cd ${GIT_REPOSITORY_PATH};
export  GITBRANCH=$(git branch --list | grep "${GIT_BRANCH_NAME}");
echo "git branch \"${GITBRANCH}\""

if [ "" == "${GITBRANCH}" ]; then
	echo "git branch -c ${GIT_BRANCH_NAME}"
	git branch -c ${GIT_BRANCH_NAME}
fi
echo "git checkout -f ${GIT_BRANCH_NAME}"
git checkout -f ${GIT_BRANCH_NAME}

