#!/bin/bash
#set -x

if [ -e .svn ]; then
	SubWCRev . svn_rev_shell.tmpl svn_rev.shell
	SubWCRev . svn_rev_scad.tmpl svn_rev.scad
else
	echo "no SVN copy, hopefully the svn_rev.* files were provided"
fi