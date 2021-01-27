export SOURCESAFE_DB=${1}
export SOURCESAFE_SUB_TREE=${2}
export SOURCESAFE_PROJECT=${3}
export SOURCESAFE_LABEL=${4}
export GIT_REPOSITORY_HOME=$(echo "${5}" | tr '[:upper:]' '[:lower:]');
export GIT_REPOSITORY_PATH=$(echo "./${6}" | tr '[:upper:]' '[:lower:]');
export GIT_BRANCH_NAME=$(echo "${SOURCESAFE_DB}_${SOURCESAFE_SUB_TREE}" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\\$");
export GIT_TAG_NAME=$(echo "${SOURCESAFE_DB}_${SOURCESAFE_PROJECT}_${SOURCESAFE_LABEL}");

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
 
~/dev-newton/scripts/ImportSourceSafeIntoGit-BuildSSVER.sh ${GIT_REPOSITORY_HOME}/${SSVERFILENAME} ${GIT_REPOSITORY_HOME};
sh -x /tmp/import.ssver.sh;
git tag -f -a -m "${GIT_TAG_NAME}" "${GIT_TAG_NAME}"
