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

if [ "$script_build_linux_for_brd_sitara" ]; then
        return
fi

export script_build_linux_for_brd_sitara="build_linux_for_brd_sitara.sh"

# get dir of the script
build_linux_for_brd_sitara_script_relaytive_path=`dirname "$0"`

# include common script
# source "./../common/common.sh"
. $basedir/./../common/common.sh
. $basedir/./../common/common_rtems_ndk.sh

#Check the environment.
check_env

#Export variable required.
export_rtems_ndk_envirment || die

#Export variable local.
export PRIVATE_BUILD_WORK_DIRECTORY=${HOME}/sayndk-sitara-board-port-linux
export RTEMS_CC=${NDK_TOOLCHAINS_PREFIX}-

if test -z "$FLAG_BUILDING_AT_EXT_DIR"; then
	export FLAG_BUILDING_AT_EXT_DIR=1
fi

. $basedir/./build_linux_common.sh



function main {
	fnct_build_linux_common sitara omap2plus_defconfig
}

#Check requirements.
check_requirements

#Main functions call.
# clean || die
main || die
print_done || die

#Print the start time and finish time.
printTime

#Hold here.
if [ "" = "$1" ]; then
pause 'Press any key to continue...' || die
fi