#!/bin/bash
# default values
FILENAME=script
DELAY=60
SHORTPATH="false"

function print_usage {
	echo "$0 <-r|--repo url> [-f|--filename <name>] [-d|--delay <delay>] [-s|--short_path]"
	echo "	-r|--repo <url>"
	echo "		should be the url of a github repository that is configured to use SSH with keys"
	echo "	-f|--filename <name>"
	echo "		name of the html page that will be created (without the .html extension). Defaults to \"script\""
	echo "	-d|--delay <delay>"
	echo "		delay, in seconds, between each synchronization with github. Defaults to 60 seconds"
	echo "	-s|--short_path"
	echo "		enables short paths in the prompt. If this flag is present, the path will only contain the inner-most directory rather than the whole path. Default=disabled"
	exit 1
}
while [[ $# -ge 1 ]]
do
	key="$1"
	case $key in
		-h|--help)
			print_usage
			;;
		-r|--repo)
			REPO="$2"
			shift # past argument
			;;
		-f|--filename)
			FILENAME="$2"
			shift # past argument
			;;
		-d|--delay)
			DELAY="$2"
			shift # past argument
			;;
		-s|--short_path)
			SHORTPATH="true"
			;;
		*)
			print_usage
		# unknown option
		;;
	esac
	shift # past argument or value
done

if [[ -z $REPO ]]; then
	print_usage
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

export SCRIPTFILE=${REPODIR}/"${FILENAME}"
export HTML_SCRIPTFILE=$SCRIPTFILE.html
export TXT_SCRIPTFILE=$SCRIPTFILE.txt

# initialize files
for FILE in $HTML_SCRIPTFILE; do
	if [[ -f $FILE ]]; then
		echo "" > $FILE
	else
		touch $FILE
	fi
done
function update_files {
	pushd $REPODIR
	for FILE in $HTML_SCRIPTFILE; do
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
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export PS1='\[\033[01;32m\]\u\[\033[01;34m\] \w \$\[\033[00m\] '

synchronize_daemon &

# intercept the kill and kills the daemonized function when this script exits
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

script -t 0 -q $TXT_SCRIPTFILE

update_files
rm -rf $TMPDIR



