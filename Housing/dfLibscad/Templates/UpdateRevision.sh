#!/bin/bash
#set -x
if [ -e .svn ]; then
	SubWCRev . svn_rev.tmpl svn_rev.shell
else
	echo "no SVN copy, hopefully the svn_rev.shell was provided"
fi

. svn_rev.shell

pushd dfLibscad
. UpdateRevision.sh
. svn_rev.shell
popd

echo $SVN_RevisionStr_dfLibscad
echo $SVN_RevisionStr
