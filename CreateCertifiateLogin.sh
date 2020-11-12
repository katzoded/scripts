
export USERNAME=${1}
export HOST=${2}
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    ssh-keygen;
fi

cat ~/.ssh/id_rsa.pub | ssh ${USERNAME}@${HOST} "cat >>~/.ssh/authorized_keys"