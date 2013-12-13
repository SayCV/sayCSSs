#! /bin/bash -e

# No Copyright @ SayCV.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#
# 2013 @ SayCV.Xiao.
#

# determine base directory; preserve where you're running from
realpath=$(readlink -f "$0")
# export basedir, so that module shell can use it. log.sh. e.g.
# export filename, so that module shell can use it. log.sh. e.g.
# basedir=$(dirname "$realpath")
export basedir=$(dirname "$realpath")
export filename=$(basename "$realpath") 

export PATH=$PATH:$basedir

# echo $basedir
# echo $filename
# echo $PATH

# include common script
# source "./../common/common.sh"
. $basedir/./../common/common.sh

print_headline "Checking that script is using UNIX line endings"
mount | grep textmode && die
print_done


function main {
	print_headline "Excute $filename"
	cd $MAVEN_HOME
	#pack_archive maven_repo.tar.gz repo
	pack_archive maven_repo.7z repo
}

main || die
print_done || die
inform "$common_date" || die
print_done || die
pause 'Press any key to continue...' || die