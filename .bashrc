#
# Place stuff that is needed for non-interactive logins in .bashrc.
# Place stuff that is only needed for interactive logins in .bash_profile.
#

if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

# set terminal prompt format
PS1="\h:\w> "
# use visual bell
xset b off

export PRINTER=gutenberg

export HOME_BIN=${HOME}/bin
export PYTHON_BIN=${HOME}/bin/python
export SCRATCH_BIN=/scratch/bin

# explicitly set the virtual memory since otherwise
# Java VM won't start up
ulimit -v unlimited 

export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
export JAVA_OPTS="-Xmx1024m -XX:MaxPermSize=128m"
export MAVEN_HOME=${SCRATCH_BIN}/apache-maven-3.0.3
export MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=128m"
export ECLIPSE_HOME=${SCRATCH_BIN}/eclipse-3.7
export DERBY_HOME=${SCRATCH_BIN}/db-derby-10.8.1.2-bin
export PATH=${DERBY_HOME}/bin:${ECLIPSE_HOME}:${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${SCRATCH_BIN}:${HOME_BIN}:${PYTHON_BIN}:${PATH}

export SVN_URL=svn://svn.cs.umu.se/2011/cloud/cloud
export GIT_URL=ssh://peppar/Home/projects/elastisys-dev/cloud.git

alias mvnci="mvn clean install"
alias mvnnt="mvn clean install -Dmaven.test.skip"
# alias emacs="emacs -fn 8x13"
alias lst="ls -al --full-time"
alias rdesktop="rdesktop -g 1440x1080"
alias o="gnome-open"

. ${HOME}/.bash_tricks
