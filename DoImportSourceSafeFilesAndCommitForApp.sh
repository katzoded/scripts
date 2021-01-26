export SOURCESAFE_DB=${1}
export SOURCESAFE_SUB_TREE=${2}
export SOURCESAFE_PROJECT=${3}
export SOURCESAFE_LABEL=${4}
export GIT_REPOSITORY_HOME=${5};
export GIT_REPOSITORY_PATH=${6};
export GIT_BRANCH_NAME=$(echo "${SOURCESAFE_DB}_${SOURCESAFE_SUB_TREE}" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\\$");

export  SSDIR=\\\\Newton\\Archive\\${SOURCESAFE_DB}

mkdir -p ${GIT_REPOSITORY_HOME}/${GIT_REPOSITORY_PATH};

cd ${GIT_REPOSITORY_HOME};


export  GITBRANCHEXISTANCE=$(git branch --list | grep "${GIT_BRANCH_NAME}");
echo "git branch \"${GITBRANCHEXISTANCE}\""

if [ "" == "${GITBRANCHEXISTANCE}" ]; then
	echo "git branch -c ${GIT_BRANCH_NAME}"
	git branch -c ${GIT_BRANCH_NAME}
fi
echo "git checkout -f ${GIT_BRANCH_NAME}"
git checkout -f ${GIT_BRANCH_NAME}


~/dev-newton/scripts/DoImportSourceSafeFilesAndCommit.sh $@
export SSVERFILENAME=$(find ${GIT_REPOSITORY_PATH} -type f | grep -i "ssver.bat")
 
ImportSourceSafeIntoGit-BuildSSVER.sh ${SSVERFILENAME} ${GIT_REPOSITORY_HOME};