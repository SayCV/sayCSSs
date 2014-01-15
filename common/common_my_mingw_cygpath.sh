#! /bin/bash -e

# No Copyright @ SayCV.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#
# 2013 @ SayCV.Xiao.
#

if [ "$script_common_my_mingw_cygpath.sh" ]; then
        return
fi

export script_common_my_mingw_cygpath="common_my_mingw_cygpath.sh"

# get dir of the script
common_my_mingw_cygpath_script_path=`dirname "$0"`

perl $common_my_mingw_cygpath_script_path/common_my_mingw_cygpath