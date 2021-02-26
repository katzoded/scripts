export SOURCESAFE_DB=${1}
export SOURCESAFE_SUB_TREE=${2}
export SOURCESAFE_PROJECT=${3}
export SOURCESAFE_LABEL=${4}
export SOURCESAFE_LABEL_VERONLY=$(echo "${SOURCESAFE_LABEL}" | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh ".*\.\([0-9][0-9a-zA-Z]*\)" "\1");
export GIT_REPOSITORY_HOME=$(echo "${5}" | tr '[:upper:]' '[:lower:]');
export GIT_REPOSITORY_PATH=$(echo "./${6}" | tr '[:upper:]' '[:lower:]');
export GIT_BRANCH_NAME=$(echo "${SOURCESAFE_DB}_${SOURCESAFE_SUB_TREE}" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\\$" \
| tr '[:upper:]' '[:lower:]');
export GIT_TAG_NAME=$(echo "${SOURCESAFE_DB}_${SOURCESAFE_SUB_TREE}_${SOURCESAFE_PROJECT}_${SOURCESAFE_LABEL_VERONLY}" \
| tr '[:upper:]' '[:lower:]' \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "\\$" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "/" );
export SSUSENAMEPASS=okatz,Johanson23
export BRANCH_FROM_CONFIGURED_BRANCHES+=($(cat /tmp/NewBranch.data.ManualUpdated | grep -w -i "${SOURCESAFE_DB} ${SOURCESAFE_SUB_TREE} ${SOURCESAFE_PROJECT}" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "${SOURCESAFE_DB} ${SOURCESAFE_SUB_TREE} ${SOURCESAFE_PROJECT}" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "\""));

echo "BRANCH_FROM_CONFIGURED_BRANCHES[0] ${BRANCH_FROM_CONFIGURED_BRANCHES[0]}
BRANCH_FROM_CONFIGURED_BRANCHES[1] ${BRANCH_FROM_CONFIGURED_BRANCHES[1]}
BRANCH_FROM_CONFIGURED_BRANCHES[2] ${BRANCH_FROM_CONFIGURED_BRANCHES[2]}"
if [ "${1}" == "sip" ]; then
	export SSUSENAMEPASS=oded,Aniston
fi

if [ "${BRANCH_FROM_CONFIGURED_BRANCHES[0]}" != "" ]; then
	export GIT_BRANCH_NAME=${BRANCH_FROM_CONFIGURED_BRANCHES[0]};
	export INITIAL_BRANCH=${BRANCH_FROM_CONFIGURED_BRANCHES[1]};
fi

export  SSDIR=\\\\Newton\\Archive\\${SOURCESAFE_DB}

mkdir -p ${GIT_REPOSITORY_HOME}/${GIT_REPOSITORY_PATH};

cd ${GIT_REPOSITORY_HOME};


export  GITBRANCHEXISTANCE=$(git branch --list | grep -w "${GIT_BRANCH_NAME}");
echo "git branch \"${GIT_BRANCH_NAME}\" exist(\"${GITBRANCHEXISTANCE}\")"

export GITBRANCHCOMMAND="git branch ${GIT_BRANCH_NAME}"
export GITCHECKOUTCOMMAND="git checkout -f ${GIT_BRANCH_NAME}"
if [ "" == "${GITBRANCHEXISTANCE}" ]; then
	if [ "" != "${INITIAL_BRANCH}" ]; then
		export GITBRANCHCOMMAND="git checkout -f ${INITIAL_BRANCH} -b ${GIT_BRANCH_NAME}"
	fi
	echo "${GITBRANCHCOMMAND}";
	echo "${GITBRANCHCOMMAND}" | sh;
fi
echo "${GITCHECKOUTCOMMAND}";
echo "${GITCHECKOUTCOMMAND}" | sh;

export Input=""; 
#while [ "${Input}" != "Continue" ]; do
	pushd ./${GIT_REPOSITORY_PATH};
	ss Get -I-Y -GL. -R -W -V"L${SOURCESAFE_LABEL}" -Y${SSUSENAMEPASS} ${SOURCESAFE_SUB_TREE}/${SOURCESAFE_PROJECT};
	popd
	export SSVERFILEISNEW=$(git status -u | grep -i ssver.bat | grep -v modified);
	export SSVERFILENAME=$(find ${GIT_REPOSITORY_PATH} -type f | grep -i "ssver.bat")
	 
	echo "SSVERFILEISNEW = ${SSVERFILEISNEW}"
	echo "SSVERFILENAME = ${SSVERFILENAME}"
 #   read Input	
	if [ "${SSVERFILEISNEW}" != "" ]; then
		~/dev-newton/scripts/ImportSourceSafeIntoGit-BuildSSVER.sh ${SSVERFILENAME} ${GIT_REPOSITORY_HOME} | tee -a /tmp/log.log;
	else
		~/dev-newton/scripts/ImportSourceSafeIntoGit-BuildSSVER.byDiff.sh ${SSVERFILENAME} ${GIT_REPOSITORY_HOME} | tee -a /tmp/log.log;
	fi
#done
git checkout -f ${GIT_BRANCH_NAME}



/tmp/import.ssver.sh  | tee -a /tmp/log.log;

~/dev-newton/scripts/DoImportSourceSafeFilesAndCommit.sh $@ | tee -a /tmp/log.log;

