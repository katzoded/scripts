git checkout ${1} ${3} ;

mkdir -p stash-${1}/${3};

rm -fr stash-${1}/${3};

cp ${3} stash-${1}/${3};

git checkout ${2} ${3};

