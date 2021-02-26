export SOURCESAFE_DB=${1}
export SOURCESAFE_SUB_TREE=${2}
export SOURCESAFE_PROJECT=${3}
export SOURCESAFE_LABEL=${4}
export SOURCESAFE_LABEL_VERONLY=$(echo "${SOURCESAFE_LABEL}" | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh ".*\.\([0-9][0-9a-zA-Z]*\)" "\1");
export GIT_REPOSITORY_HOME=$(echo "${5}" | tr '[:upper:]' '[:lower:]');
export GIT_REPOSITORY_PATH=$(echo "./${6}" | tr '[:upper:]' '[:lower:]');
export GIT_TAG_NAME=$(echo "${SOURCESAFE_DB}_${SOURCESAFE_SUB_TREE}_${SOURCESAFE_PROJECT}_${SOURCESAFE_LABEL_VERONLY}" \
| tr '[:upper:]' '[:lower:]' \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "\\$" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "/" );
export  SSDIR=\\\\Newton\\Archive\\${SOURCESAFE_DB}
export SSUSENAMEPASS=okatz,Johanson23

if [ "${1}" == "sip" ]; then
	export SSUSENAMEPASS=oded,Aniston
fi

mkdir -p ${GIT_REPOSITORY_HOME}/${GIT_REPOSITORY_PATH};

cd ${GIT_REPOSITORY_HOME};

export  GITTAGEXISTANCE=$(git tag --list | grep -w "${GIT_TAG_NAME}");
echo "git tag \"${GIT_TAG_NAME}\" existance(\"${GITTAGEXISTANCE}\")"

if [ "" == "${GITTAGEXISTANCE}" ]; then
    rm -fr ${GIT_REPOSITORY_PATH}/*;
	cd ${GIT_REPOSITORY_HOME}/${GIT_REPOSITORY_PATH};
    ss Get -I-Y -GL. -R -W -V"L${SOURCESAFE_LABEL}" -Y${SSUSENAMEPASS} ${SOURCESAFE_SUB_TREE}/${SOURCESAFE_PROJECT};
    find ./ -name "*.scc" | xargs rm
	cd ${GIT_REPOSITORY_HOME};
    git add ${GIT_REPOSITORY_PATH}
    git commit -m "${GIT_TAG_NAME}" ${GIT_REPOSITORY_PATH};
    git tag -f -a -m "${GIT_TAG_NAME}" "${GIT_TAG_NAME}"
else
    git checkout -f ${GIT_TAG_NAME} ${GIT_REPOSITORY_PATH}
    git commit -m "${GIT_TAG_NAME}" ${GIT_REPOSITORY_PATH};
fi

