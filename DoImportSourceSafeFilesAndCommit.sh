export SOURCESAFE_DB=${1}
export SOURCESAFE_SUB_TREE=${2}
export SOURCESAFE_PROJECT=${3}
export SOURCESAFE_LABEL=${4}
export GIT_REPOSITORY_PATH=${5};
export GIT_BRANCH_NAME=$(echo "${SOURCESAFE_DB}_${SOURCESAFE_SUB_TREE}" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\\$");

export  SSDIR=\\\\Newton\\Archive\\${SOURCESAFE_DB}

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

rm -fr ${GIT_REPOSITORY_PATH}/*;
ss Get -I-Y -GL. -R -W -V"L${SOURCESAFE_LABEL}" -Yokatz,Johanson23 ${SOURCESAFE_SUB_TREE}/${SOURCESAFE_PROJECT};
find ${GIT_REPOSITORY_PATH} -name "*.scc" | xargs rm
git add ./
git tag -f -a -m "${SOURCESAFE_DB}_${SOURCESAFE_PROJECT}_${SOURCESAFE_LABEL}" "${SOURCESAFE_DB}_${SOURCESAFE_PROJECT}_${SOURCESAFE_LABEL}"
git commit -m "${SOURCESAFE_LABEL}" ./;
