export SOURCESAFE_DB=${1}
export SOURCESAFE_SUB_TREE=${2}
export SOURCESAFE_PROJECT=${3}
export SOURCESAFE_LABEL=${4}
export GIT_REPOSITORY_HOME=${5};
export GIT_REPOSITORY_PATH=${6};
export GIT_TAG_NAME=$(echo "${SOURCESAFE_DB}_${SOURCESAFE_PROJECT}_${SOURCESAFE_LABEL}");

export  SSDIR=\\\\Newton\\Archive\\${SOURCESAFE_DB}

mkdir -p ${GIT_REPOSITORY_HOME}/${GIT_REPOSITORY_PATH};

cd ${GIT_REPOSITORY_HOME};

export  GITTAGEXISTANCE=$(git tag --list | grep "${GIT_TAG_NAME}");
echo "git tag \"${GITTAGEXISTANCE}\""

if [ "" == "${GITTAGEXISTANCE}" ]; then
    rm -fr ${GIT_REPOSITORY_PATH}/*;
    ss Get -I-Y -GL. -R -W -V"L${SOURCESAFE_LABEL}" -Yokatz,Johanson23 ${SOURCESAFE_SUB_TREE}/${SOURCESAFE_PROJECT};
    find ${GIT_REPOSITORY_PATH} -name "*.scc" | xargs rm
    git add ${GIT_REPOSITORY_PATH}
    git tag -f -a -m "${GIT_TAG_NAME}" "${GIT_TAG_NAME}"
    git commit -m "${SOURCESAFE_LABEL}" ${GIT_REPOSITORY_PATH};
else
    git checkout -f ${GIT_TAG_NAME} ${GIT_REPOSITORY_PATH}
fi

