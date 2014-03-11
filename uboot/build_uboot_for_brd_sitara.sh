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

if [ "$script_build_uboot_for_brd_sitara" ]; then
        return
fi

export script_build_uboot_for_brd_sitara="build_uboot_for_brd_sitara.sh"

# get dir of the script
build_uboot_for_brd_sitara_script_relaytive_path=`dirname "$0"`

# include common script
# source "./../common/common.sh"
. $basedir/./../common/common.sh
. $basedir/./../common/common_rtems_ndk.sh

PRIVATE_BUILD_WORK_DIRECTORY=$HOME/sayndk-sitara-board-port-uboot
UBOOT_CC=${NDK_TOOLCHAINS_PREFIX}-

. $basedir/./build_uboot_common.sh



function main {
	fnct_build_uboot_common sitara am335x_evm_config
}

#Check the environment.
check_env

#Check requirements.
check_requirements

#Export variable required.
export_rtems_ndk_envirment || die

clean || die
main || die
print_done || die

#Print the start time and finish time.
printTime

#Hold here.
if [ "" = "$1" ]; then
pause 'Press any key to continue...' || die
fi