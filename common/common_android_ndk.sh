#! /bin/bash -e

# No Copyright @ SayCV.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#
# 2013 @ SayCV.Xiao.
#

if [ "$script_common_android_ndk" ]; then
        return
fi

export script_common_android_ndk="common_android_ndk.sh"

# get dir of the script
common_android_ndk_script_path=`dirname "$0"`

function export_android_ndk_envirment {
	print_headline "Export Android NDK Envirment"
	
	export NDK_ROOT="$NDK_ROOT"
	export NDK_TOOLCHAINS_ROOT="$NDK_ROOT/toolchains/arm-linux-androideabi-4.8/prebuilt/windows"
	export NDK_TOOLCHAINS_PREFIX="$NDK_TOOLCHAINS_ROOT/bin/arm-linux-androideabi"
	export NDK_TOOLCHAINS_INCLUDE="$NDK_TOOLCHAINS_ROOT/lib/gcc/arm-linux-androideabi/4.8/include-fixed"
#	export PATH=$NDK_TOOLCHAINS_ROOT/bin:$PATH
	
	export NDK_PLATFORM_ROOT=$NDK_ROOT/platforms/android-18/arch-arm
	export NDK_PLATFORM_INCLUDE=$NDK_PLATFORM_ROOT/usr/include
	export NDK_PLATFORM_LIB=$NDK_PLATFORM_ROOT/usr/lib
	
	
	export NDK_EXTRA_OBJS="$NDK_PLATFORM_LIB/crtbegin_dynamic.o $NDK_PLATFORM_LIB/crtend_android.o"
	export NDK_LD_FLAGS="-Bdynamic -Wl,-dynamic-linker,/system/bin/linker -nostdlib"
	
	export NDK_EXTRA_LIBS_0="-lstdc++ \
												-lgcc \
												-lc"
	export NDK_EXTRA_LIBS_1="-lgnustl_static \
												-lstdc++ \
												-lgcc \
												-lc"
	export NDK_EXTRA_LIBS=
	export SYSROOT=$NDK_PLATFORM_ROOT
#	export CFLAGS="--sysroot=$SYSROOT -I$NDK_TOOLCHAINS_INCLUDE -I$NDK_PLATFORM_INCLUDE"
#	export CC="$NDK_TOOLCHAINS_ROOT/bin/arm-linux-androideabi-gcc --sysroot=$SYSROOT"
#	export LDFLAGS="-L$NDK_PLATFORM_LIB $NDK_EXTRA_LIBS -nostdlib"
	
	print_done
}
