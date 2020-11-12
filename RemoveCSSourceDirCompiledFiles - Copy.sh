git status -s --ignored | grep "\!\!" | grep "\.o" | /home/okatz/scripts/ReplaceFileList.sh ".* " | xargs rm -f
git status -s --ignored | grep "??" | grep "lexer" | /home/okatz/scripts/ReplaceFileList.sh ".* " | xargs rm -f
git status -s --ignored | grep "??" | grep "grammar" | /home/okatz/scripts/ReplaceFileList.sh ".* " | xargs rm -f
./bootstrap.sh

cd ../okatz_5.11.0.bicc.il.build/

if [ "$(uname)" == "SunOS" ];    then	
    ../okatz_5.11.0.bicc.il/configure CC="gcc -m64" CXX="g++ -m64" CFLAGS="" CXXFLAGS="" CPPFLAGS="" LDFLAGS="-L/usr/sfw/lib/amd64 -R/usr/sfw/lib/amd64 -L/usr/lib/amd64 -R/usr/lib/amd64"
fi

if [ "$(uname)" == "Linux" ];    then	
    ../okatz_5.11.0.bicc.il/configure 'CC=gcc -m64' 'CXX=g++ -m64'
fi

