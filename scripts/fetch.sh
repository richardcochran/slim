#!/bin/bash

set -e
set -o pipefail
trap error_exit ERR

do_clone()
{
    #
    # If the directory does not exist, assume it is a remote allowing
    # the git-archive command.
    #
    [ ! -d "$slimgit" ] && return
    #
    # If the directory exists, assume it is the cloned repository.
    #
    [ -d "$slimgit/$dirname" ] && return
    #
    # Clone the remote git URL.
    #
    cd "$slimgit"
    echo "   CLONE    $source/$dirname as $slimgit"
    git clone  --bare $source/$dirname $dirname
}

error_exit()
{
    echo
    echo "`basename $0`: FATAL ERROR"
    echo
    case "$method" in
	git)
	    echo "git archive --format=tar --prefix=$dirname/ \\"
	    echo "    --remote=$slimgit/$dirname $tag | gzip > $file"
	    ;;
	wget)
	    echo wget "$source/$file"
	    ;;
    esac
    echo
    exit 1
}

usage ()
{
    echo ""
    echo "usage: `basename $0` [ARGS]"
    echo ""
    echo "-d destination directory (defaults to \$dld)"
    echo "-f file"
    echo "-h shows this message"
    echo "-m method"
    echo "-s source url or git remote"
    echo "-t tag (only used for git, defaults to 'master')"
    echo "-u upstream tag (only used for git)"
    echo ""
}

dest=$dld
tag=master
slimgit=$SLIM_GIT
[ -z "$slimgit" ] && slimgit=$HOME/slim_git

while getopts :d:hf:m:s:t:u: OPT; do
    case $OPT in
	d)
	    dest="$OPTARG"
	    ;;
	f)
	    file="$OPTARG"
	    ;;
	m)
	    method="$OPTARG"
	    ;;
	s)
	    source="$OPTARG"
	    ;;
	t)
	    tag="$OPTARG"
	    ;;
	u)
	    upstream="$OPTARG"
	    ;;
	h)
	    usage
	    exit 0
	    ;;
	*)
	    usage
	    exit 1
    esac
done
shift `expr $OPTIND - 1`
OPTIND=1

if [ -z "$file" ]; then
    echo "Need a file name."
    usage
    exit 1
fi
if [ -z "$method" ]; then
    echo "Need a download method."
    usage
    exit 1
fi
if [ -z "$source" ]; then
    echo "Need a source url."
    usage
    exit 1
fi

case "$method" in
    git)
	dirname=`basename $file .tgz`
	do_clone
	cd "$dest"
	git archive --format=tar --prefix=$dirname/ --remote=$slimgit/$dirname $tag | \
	    gzip > $file
	if [ ! -z "$upstream" ]; then
	    git archive --format=tar --prefix=upstream_$dirname/ \
		--remote=$slimgit/$dirname $upstream | gzip > upstream_$file
	fi
	;;
    wget)
	cd "$dest"
	if [ -n "$SLIM_WGET_MIRROR" ]; then
	    echo "   FETCH    from $SLIM_WGET_MIRROR instead of $source"
	    source="$SLIM_WGET_MIRROR"
	fi
	if [ -f "../../download/$file" ]; then
	    echo "   FETCH    already have $file in main download area"
	else
	    wget "$source/$file"
	    mv "$file" "../../download/$file"
	fi
	ln -f "../../download/$file" "$file"
	;;
    *)
	echo "unknown download method"
	exit 1
esac

exit 0
