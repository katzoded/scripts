export SOURCESAFE_DB=${1}
export SOURCESAFE_SUB_TREE=${2}
export SOURCESAFE_PROJECT=${3}
export SOURCESAFE_LABEL=${4}
export GIT_REPOSITORY_PATH=${5}

export  SSDIR=\\\\Newton\\Archive\\${SOURCESAFE_DB}

mkdir -p ${GIT_REPOSITORY_PATH}/${SOURCESAFE_DB}/${SOURCESAFE_PROJECT};

cd ${GIT_REPOSITORY_PATH}/${SOURCESAFE_DB}/${SOURCESAFE_PROJECT};
export  GITBRANCH=$(git branch --list | grep "${SOURCESAFE_SUB_TREE}");
echo "git branch \"${GITBRANCH}\""

if [ "" == "${GITBRANCH}" ]; then
	echo "git checkout -B ${SOURCESAFE_SUB_TREE}"
	git checkout -B ${SOURCESAFE_SUB_TREE}
else
	echo "git checkout -f ${SOURCESAFE_SUB_TREE}"
	git checkout -f ${SOURCESAFE_SUB_TREE}
fi

rm -fr ${GIT_REPOSITORY_PATH}/${SOURCESAFE_DB}/${SOURCESAFE_PROJECT}/*;
ss Get -I- -GL. -R -W -V"L${SOURCESAFE_LABEL}" -Yokatz,Johanson23 ${SOURCESAFE_SUB_TREE}/${SOURCESAFE_PROJECT};
cd ${GIT_REPOSITORY_PATH}/
find ${SOURCESAFE_DB}/${SOURCESAFE_PROJECT} -name "*.scc" | xargs rm
git add ${SOURCESAFE_DB}/${SOURCESAFE_PROJECT}
git commit -m "${SOURCESAFE_LABEL}" ${SOURCESAFE_DB}/${SOURCESAFE_PROJECT};
git tag -f -a -m "${SOURCESAFE_LABEL}" ${SOURCESAFE_LABEL}
