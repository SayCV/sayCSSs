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

if [ "$script_build_uboot_common" ]; then
        return
fi

export script_build_uboot_common="build_uboot_common.sh"

# get dir of the script
build_uboot_common_script_relaytive_path=`dirname "$0"`

# include common script
# source "./../common/common.sh"
. $basedir/./../common/common.sh
. $basedir/./../common/common_rtems_ndk.sh

# PRIVATE_BUILD_WORK_DIRECTORY=$HOME/sayndk-sitara-board-port-uboot
# UBOOT_CC=${NDK_TOOLCHAINS_PREFIX}-
echo ${PRIVATE_BUILD_WORK_DIRECTORY}
echo ${UBOOT_CC}

check_requirements(){
	print_headline "Checking requirements for ${1}"
	inform "Nothing to do."
	print_done
}

function fnct_autogen_uboot_for_target_brd {
	print_headline "Autogening uboot for ${1}"
	inform "Nothing to do."
	print_done
}

function fnct_configure_uboot_for_target_brd {
	print_headline "Configuring uboot for ${1}"
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_configure_uboot_for_${1}_h"; then
		# make ARCH=arm CROSS_COMPILE=${CC} am335x_evm_config
		make ARCH=arm CROSS_COMPILE=${UBOOT_CC} ${2} || die
		touch stamp_configure_uboot_for_${1}_h
		inform "Done it."
	else
		inform "Nothing to do."
	fi
	print_done
}

function fnct_hacking_before_make_uboot_for_target_brd {
	print_headline "Doing hack before make uboot for ${1}"
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	inform "Nothing to do."
	print_done
}

function fnct_make_uboot_for_target_brd {
	print_headline "Making uboot for ${1}"
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_make_uboot_for_${1}_h"; then
		make ARCH=arm CROSS_COMPILE=${UBOOT_CC} || die
		touch stamp_make_uboot_for_${1}_h
		inform "Done it."
	else
		inform "Nothing to do."
	fi
}

function fnct_make_install_uboot_for_target_brd {
	print_headline "Making install uboot for ${1}"
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_make_install_uboot_for_${1}_h"; then
		touch stamp_make_install_uboot_for_${1}_h
		inform "Done it."
	else
		inform "Nothing to do."
	fi
}

function fnct_hacking_after_make_install_uboot_for_target_brd {
	print_headline "Doing hack after make install uboot for ${1}"
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_hacking_after_make_install_uboot_for_${1}_h"; then
		inform "Nothing to do."
		touch stamp_hacking_after_make_install_uboot_for_${1}_h
		inform "Done it."
	else
		inform "Nothing to do."
	fi
	print_done
}

clean(){
	print_headline "Cleaning uboot"
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_clean_uboot_common_h"; then
		make ARCH=arm CROSS_COMPILE=${UBOOT_CC} distclean || die
		touch stamp_clean_uboot_common_h
		inform "Done it."
	else
		inform "Nothing to do."
	fi
	print_done
}

function fnct_build_uboot_common {
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_build_uboot_common$suffix_skip_checking_stamp_h"; then
		print_headline "Building uboot for ${1}"
			fnct_autogen_uboot_for_target_brd ${1} ${2}
			fnct_configure_uboot_for_target_brd ${1} ${2}
			fnct_hacking_before_make_uboot_for_target_brd ${1} ${2}
			fnct_make_uboot_for_target_brd ${1} ${2}
			# fnct_hacking_before_make_install_uboot_for_target_brd ${1} ${2}
			fnct_make_install_uboot_for_target_brd ${1} ${2}
			fnct_hacking_after_make_install_uboot_for_target_brd ${1} ${2}
		print_done
	else
		inform "Nothing to do."
	fi
}
