#!/bin/bash
echo $0
REPO=$1
if [[ $# -gt 1 ]]; then
	FILENAME=$2
else
	FILENAME=script
fi
if [[ $# -gt 2 ]]; then
	DELAY=$3
else
	DELAY=60
fi

# clone the repo in a temporary directory
TMPDIR=/tmp/$$.$RANDOM
mkdir $TMPDIR
pushd $TMPDIR
git clone $REPO

REPONAME=$(ls $DIR)
REPODIR="$TMPDIR/$REPONAME"
cd $REPODIR
git pull origin gh-pages
git branch gh-pages
git checkout gh-pages
#git config --global push.default matching

export HISTFILE=${REPODIR}/command_history.txt
export SCRIPTFILE=${REPODIR}/"${FILENAME}"
export HTML_SCRIPTFILE=$SCRIPTFILE.html
export TXT_SCRIPTFILE=$SCRIPTFILE.txt

# initialize files
for FILE in $HISTFILE $HTML_SCRIPTFILE; do
	if [[ -f $FILE ]]; then
		echo "" > $FILE
	else
		touch $FILE
	fi
done
function update_files {
	pushd $REPODIR
	for FILE in $HISTFILE $HTML_SCRIPTFILE; do
		git add $FILE
	done
	git commit -m 'updated history and script files' > /dev/null
	git push origin gh-pages
	popd
}
update_files 2>/dev/null >/dev/null
function synchronize_daemon {
  while true; do
	  cat $TXT_SCRIPTFILE 2>/dev/null | ansi2html.sh --bg=dark > $HTML_SCRIPTFILE
	  update_files 2>/dev/null >/dev/null
	  sleep $DELAY
  done
}

popd
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export PS1='\[\033[01;32m\]\u\[\033[01;34m\] \w \$\[\033[00m\] '

synchronize_daemon &

# intercept the kill and kills the daemonized function when this script exits
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

script -t 0 -q $TXT_SCRIPTFILE

update_files
rm -rf $TMPDIR



