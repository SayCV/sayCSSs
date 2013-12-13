#! /bin/bash -e

# No Copyright @ SayCV.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#
# 2013 @ SayCV.Xiao.
#

# get dir of the script
the_script_path=`dirname "$0"`

# include common script
source "../common/common.sh"

print_headline "Checking that script is using UNIX line endings"
mount | grep textmode && die
print_done

function main {
	inform "$common_script_path"
	inform "$common_date"
	inform "$the_script_path"
	system (pause)
}

main || die