#
# Keep stuff required for interactive logins in this file.
# Stuff that is needed for non-interactive logins should be placed in .bashrc.
#

. $HOME/.bashrc

# This line was added by rvm (Ruby Version Manager)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# In order to be able to use the CloudFoundry command-line client (vmc)
#   vmc target http://api.peterg.cloudfoundry.me
#   vmc login --email peterg@cs.umu.se --passwd donaldduck
rvm use 1.9.2

