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

PRIVATE_BUILD_WORK_DIRECTORY=$HOME/sigar

check_requirements(){

	inform "GCJ absolutely requires ECJ for compiling Java sources. "
	inform "You can either download the necessary jar manually, as mentioned previously, "
	inform "or install the java-ecj package from Ports."
	local usr_share_java_root=/usr/share/java
	if ! test -f "${usr_share_java_root}/ecj.jar";then
		inform "Start to download ecj.jar"
		
		cd ${usr_share_java_root}
#		wget ftp://ftp.freebsd.org/pub/FreeBSD/ports/distfiles/ecj-4.5.jar || die
#		wget ftp://sourceware.org/pub/java/ecj-latest.jar || die
		wget http://download.eclipse.org/eclipse/updates/4.4milestones/S-4.4M4-201312121600/plugins/org.eclipse.jdt.core_3.10.0.v20131208-1955.jar \
		|| die
		cp -rf org.eclipse.jdt.core_3.10.0.v20131208-1955.jar ecj.jar || die
		
		print_done || die
	fi

	if ! test -f "${usr_share_java_root}/ecjx.exe";then
    inform "Start to compile ecj.jar to generate ecj.exe"
    
    cd ${usr_share_java_root}
		gcj -o ecjx.exe -findirect-dispatch \
			--main=org.eclipse.jdt.internal.compiler.batch.GCCMain \
			/usr/share/java/ecj.jar \
		|| die
#   Now call ecj will error with no classpath specified, So ...
#		cp -rf ecjx.exe /usr/bin/ecj.exe
		print_done || die
	fi
}

function fnct_autogen_sigar_for_android {
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_autogen_sigar_for_android_h"; then
		print_headline "Autogen sigar for android"
		./autogen.sh \
			>${HOME}/log-fnct_autogen_sigar_for_android.log 2>&1 \
		|| die
		touch stamp_autogen_sigar_for_android_h
	fi
}

#			CFLAGS="--sysroot=$SYSROOT -nostdlib -I$NDK_TOOLCHAINS_INCLUDE -I$NDK_PLATFORM_INCLUDE"
function fnct_configure_sigar_for_android {
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_configure_sigar_for_android_h"; then
		print_headline "Configure sigar for android"
		./configure \
			--prefix=/tmp/sigar \
			--disable-gtk-peer --disable-gconf-peer --disable-plugin \
			--disable-Werror \
			--enable-static=yes \
			--enable-shared=no \
			--host=arm-linux-androideabi \
			--with-sysroot=${SYSROOT} \
			--with-ecj-jar=${ECLIPSE_JAVA_COMPILER_JAR} \
			CFLAGS="-nostdlib -I${NDK_TOOLCHAINS_INCLUDE} -I${NDK_PLATFORM_INCLUDE}" \
			LDFLAGS="-nostdlib -L${NDK_PLATFORM_LIB} ${NDK_EXTRA_LIBS}" \
			>${HOME}/log-fnct_configure_sigar_for_android.log 2>&1 \
		|| die
		touch stamp_configure_sigar_for_android_h
	fi
}

function fnct_hacking_copy_android_platforms_libso_files {
	cd $1
	if ! test -f "crtbegin_so.o"; then
#		cd ${PRIVATE_BUILD_WORK_DIRECTORY}/native/jni/java-io
#		ln -s ${NDK_PLATFORM_LIB}/crtbegin_so.o 
#		ln -s ${NDK_PLATFORM_LIB}/crtend_so.o 
		cp -rf ${NDK_PLATFORM_LIB}/crtbegin_so.o crtbegin_so.o
		cp -rf ${NDK_PLATFORM_LIB}/crtend_so.o crtend_so.o
	fi
}

function fnct_hacking_before_make_sigar_for_android {
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_hacking_before_make_sigar_for_android_h"; then
		print_headline "Hacking before make sigar for android"
		
		print_headline "Fixed jni_md.h symlink not work on cygwin instead of copy original file and rename to jni_md.h"
		cd $PRIVATE_BUILD_WORK_DIRECTORY/include || die
		cp -rf jni_md-x86-linux-gnu.h jni_md.h || die
#sed -i '/<localRepository>/{/<\/localRepository>/s/.*/  <localRepository>D:\/Android\/maven\/repo<\/localRepository>/g}' $M2_HOME/conf/settings.xml	
		print_headline 'Removing include ./$(DEPDIR)/***.Plo of repeat'
#			cd $PRIVATE_BUILD_WORK_DIRECTORY || die
#			find . -path "./doc" -prune -o -name "Makefile" |
#				xargs perl -pi -e 's|include .*.Plo| |g'
		
		print_headline "we add a sym link to crtbegin_so.o, crtend_so.o in the source folder"
#		fnct_hacking_copy_android_platforms_libso_files ${PRIVATE_BUILD_WORK_DIRECTORY}/native/jni/java-io
#		fnct_hacking_copy_android_platforms_libso_files ${PRIVATE_BUILD_WORK_DIRECTORY}/native/jni/java-lang
#		fnct_hacking_copy_android_platforms_libso_files ${PRIVATE_BUILD_WORK_DIRECTORY}/native/jni/java-net
#		fnct_hacking_copy_android_platforms_libso_files ${PRIVATE_BUILD_WORK_DIRECTORY}/native/jni/java-nio 
#		fnct_hacking_copy_android_platforms_libso_files ${PRIVATE_BUILD_WORK_DIRECTORY}/native/jni/java-util
		
		print_headline "Skip to building tools directory."
		print_headline 'Removing  $(TOOLSDIR) $(EXAMPLESDIR) at SUBDIRS in Makefile'
			cd $PRIVATE_BUILD_WORK_DIRECTORY || die
			find . -maxdepth 1 -name "Makefile" |
				xargs perl -pi -e 's|SUBDIRS = lib doc external include native resource scripts $(TOOLSDIR) $(EXAMPLESDIR)|SUBDIRS = lib doc external include native resource scripts|g'
			find . -maxdepth 1 -name "Makefile" |
				xargs perl -pi -e 's|DIST_SUBDIRS = lib doc external include native resource scripts tools examples|DIST_SUBDIRS = lib doc external include native resource scripts|g'

		touch stamp_hacking_before_make_sigar_for_android_h
	fi
}

function fnct_make_sigar_for_android {
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_make_sigar_for_android_h"; then
		print_headline "Make sigar for android"
		make \
			>${HOME}/log-fnct_make_sigar_for_android.log 2>&1 \
		|| die
		touch stamp_make_sigar_for_android_h
	fi
}

function fnct_make_install_sigar_for_android {
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_make_install_sigar_for_android_h"; then
		print_headline "Make install sigar for android"
		make install \
			>${HOME}/log-fnct_make_install_sigar_for_android.log 2>&1 \
		|| die
		touch stamp_make_install_sigar_for_android_h
	fi
}

function fnct_hacking_after_make_install_sigar_for_android {
	cd $PRIVATE_BUILD_WORK_DIRECTORY || die
	if ! test -f "stamp_hacking_after_make_install_sigar_for_android_h"; then
		print_headline "Hacking after make install sigar for android"
		cd /tmp/sigar
		mkdir -p libTogether
		cd libTogether
		ar x ../libsigar.a
		
		cd $PRIVATE_BUILD_WORK_DIRECTORY || die
		touch stamp_hacking_after_make_install_sigar_for_android_h
	fi
}

function fnct_build_uboot_for_brd_sitara {
    cd $PRIVATE_BUILD_WORK_DIRECTORY || die
    if ! test -f "stamp_build_uboot_for_brd_sitara$suffix_skip_checking_stamp_h"; then
        print_headline "Building sigar for android"
        		fnct_hacking_before_building_for_android $PRIVATE_BUILD_WORK_DIRECTORY
            fnct_autogen_sigar_for_android
            fnct_configure_sigar_for_android
            fnct_hacking_before_makeing_for_android $PRIVATE_BUILD_WORK_DIRECTORY
#            fnct_hacking_before_make_sigar_for_android
						fnct_hacking_copy_android_platforms_libso_files ${PRIVATE_BUILD_WORK_DIRECTORY}/src
            fnct_make_sigar_for_android
            fnct_hacking_before_makeing_install_for_android $PRIVATE_BUILD_WORK_DIRECTORY
            fnct_make_install_sigar_for_android
        print_done
    fi
}

clean(){
    if [ "$1" = "clean" ];then
		echo "ndk-build clean"
		ndk-build clean
		#echo "rm bin libs obj -rf"
		rm bin libs obj -rf
		exit 0
    fi
}

function main {
	export_android_ndk_envirment || die
	fnct_build_uboot_for_brd_sitara || die
}

#Check the environment.
check_env

#Check requirements.
check_requirements

#check whether it is ndk-build clean,and exit.
#clean $1

main || die
print_done || die

#Print the start time and finish time.
printTime

#Hold here.
if [ "" = "$1" ]; then
pause 'Press any key to continue...' || die
fi