#!/bin/bash

set -e

#
# Set user details
#
git config --global user.email 'peter.gardfjall.work@gmail.com'
git config --global user.name  'Peter Gardfjäll'

#
# Keep username/password credentials cached for N seconds.
#
git config --global credential.helper 'cache --timeout=14400'

#
# Show changes in submodules as list of commit messages.
#
git config --global diff.submodule 'log'


#
# Pretty diffs with refined highlighting of changes.
# Requires diffr to be installed: https://github.com/mookid/diffr
#
git config --global core.pager 'diffr --colors refine-added:none:background:23,91,43:nobold --colors added:none:background:3,53,33 --colors refine-removed:none:background:141,35,35:nobold --colors removed:none:background:59,15,25 | less'

git config --global interactive.difffilter 'diffr --colors refine-added:none:background:23,91,43:nobold --colors added:none:background:3,53,33 --colors refine-removed:none:background:141,35,35:nobold --colors removed:none:background:59,15,25'
