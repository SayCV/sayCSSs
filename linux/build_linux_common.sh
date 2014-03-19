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

if [ "$script_build_linux_common" ]; then
        return
fi

export script_build_linux_common="build_linux_common.sh"

# get dir of the script
build_linux_common_script_relaytive_path=`dirname "$0"`

# include common script
# source "./../common/common.sh"
. $basedir/./../common/common.sh
. $basedir/./../common/common_rtems_ndk.sh

# PRIVATE_BUILD_WORK_DIRECTORY=${HOME}/sayndk-sitara-board-port-linux
# RTEMS_CC=${NDK_TOOLCHAINS_PREFIX}-
echo ${PRIVATE_BUILD_WORK_DIRECTORY}
echo ${RTEMS_CC}

check_requirements(){
	print_headline "Checking requirements for ${1}"
	# inform "Nothing to do."
	warning "Required bc.exe building latest linux on cygwin."
	print_done
}

function fnct_autogen_linux_for_target_brd {
	print_headline "Autogening linux for ${1}"
	inform "Nothing to do."
	print_done
}

function fnct_hacking_before_configure_linux_for_target_brd {
	print_headline "Doing hack before configure linux for ${1}"
	cd ${PRIVATE_BUILD_WORK_DIRECTORY} || die
	if [ ${FLAG_BUILDING_AT_EXT_DIR} = 1 ] ; then
		inform "Building at external directory."
		mkdir -p ${HOME}/building_linux_dir
		export KDIR=${HOME}/building_linux_dir
		# export PRIVATE_BUILD_WORK_DIRECTORY=${HOME}/building_linux_dir
		inform "${PRIVATE_BUILD_WORK_DIRECTORY}."
		inform "Done it."
	else
		inform "Nothing to do."
	fi
	print_done
}

function fnct_configure_linux_for_target_brd {
	print_headline "Configuring linux for ${1}"
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if [ ${FLAG_BUILDING_AT_EXT_DIR} = 1 ] ; then
		if [ ! -f $KDIR/.config ] ; then
			cd $PRIVATE_BUILD_WORK_DIRECTORY || die
			# make ARCH=arm at91sam9x5ek_defconfig
			# make -C $KDIR M=$PWD ARCH=arm CROSS_COMPILE=${RTEMS_CC} ${2} || die
			make O=$KDIR ARCH=arm CROSS_COMPILE=${RTEMS_CC} ${2} || die
			make ARCH=arm menuconfig || die
			cd $KDIR
			patch -bp1 < $basedir/./001-Fixed_defconfig_drivers_video_logo_mono_missing.patch
		else
			inform "Nothing to do."
		fi
	else
		if [ ! -f .config ] ; then
			cd $PRIVATE_BUILD_WORK_DIRECTORY || die
			make ARCH=arm CROSS_COMPILE=${RTEMS_CC} ${2} || die
			make ARCH=arm menuconfig || die
			patch -bp1 < $basedir/./001-Fixed_defconfig_drivers_video_logo_mono_missing.patch
		else
			inform "Nothing to do."
		fi
	fi
	inform "Done it."
	print_done
}

function fnct_hacking_before_make_linux_for_target_brd {
	print_headline "Doing hack before make linux for ${1}"
	cd ${PRIVATE_BUILD_WORK_DIRECTORY} || die
	inform "Nothing to do."
	print_done
}

function fnct_make_linux_for_target_brd {
	print_headline "Making linux for ${1}"
	cd ${PRIVATE_BUILD_WORK_DIRECTORY} || die
	if ! test -f "stamp_make_linux_for_${1}_h"; then
		if [ ${FLAG_BUILDING_AT_EXT_DIR} = 1 ] ; then
			make O=$KDIR ARCH=arm CROSS_COMPILE=${RTEMS_CC} >${HOME}/log-Making_linux_for_${1}.log 2>&1 || die
		else
			make ARCH=arm CROSS_COMPILE=${RTEMS_CC} >${HOME}/log-Making_linux_for_${1}.log 2>&1 || die
		fi
		touch stamp_make_linux_for_${1}_h
		inform "Done it."
	else
		inform "Nothing to do."
	fi
}

function fnct_make_install_linux_for_target_brd {
	print_headline "Making install linux for ${1}"
	cd ${PRIVATE_BUILD_WORK_DIRECTORY} || die
	if ! test -f "stamp_make_install_linux_for_${1}_h"; then
		touch stamp_make_install_linux_for_${1}_h
		inform "Done it."
	else
		inform "Nothing to do."
	fi
}

function fnct_hacking_after_make_install_linux_for_target_brd {
	print_headline "Doing hack after make install linux for ${1}"
	cd ${PRIVATE_BUILD_WORK_DIRECTORY} || die
	if ! test -f "stamp_hacking_after_make_install_linux_for_${1}_h"; then
		inform "Nothing to do."
		touch stamp_hacking_after_make_install_linux_for_${1}_h
		inform "Done it."
	else
		inform "Nothing to do."
	fi
	print_done
}

clean(){
	print_headline "Cleaning linux"
	cd ${PRIVATE_BUILD_WORK_DIRECTORY} || die
	if ! test -f "stamp_clean_linux_common_h"; then
		make ARCH=arm CROSS_COMPILE=${RTEMS_CC} distclean || die
		touch stamp_clean_linux_common_h
		inform "Done it."
	else
		inform "Nothing to do."
	fi
	print_done
}

function fnct_build_linux_common {
	cd ${PRIVATE_BUILD_WORK_DIRECTORY} || die
	if ! test -f "stamp_build_linux_common$suffix_skip_checking_stamp_h"; then
		print_headline "Building linux for ${1}"
			fnct_autogen_linux_for_target_brd ${1} ${2}
			fnct_hacking_before_configure_linux_for_target_brd ${1} ${2}
			fnct_configure_linux_for_target_brd ${1} ${2}
			fnct_hacking_before_make_linux_for_target_brd ${1} ${2}
			fnct_make_linux_for_target_brd ${1} ${2}
			# fnct_hacking_before_make_install_linux_for_target_brd ${1} ${2}
			fnct_make_install_linux_for_target_brd ${1} ${2}
			fnct_hacking_after_make_install_linux_for_target_brd ${1} ${2}
		print_done
	else
		inform "Nothing to do."
	fi
}
