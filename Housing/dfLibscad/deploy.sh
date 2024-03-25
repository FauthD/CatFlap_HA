#!/bin/bash
#set -x

. UpdateRevision.sh
. svn_rev.shell

7z -xr@ExcludeList.txt a ../${SVN_RevisionStr_dfLibscad}.zip '../dfLibscad'
