### Creating a repo

Create a git repo that is to be shared and written by different group
members. This sets the `sharedRepository` option in the repository
config, which ensures that all members of the UNIX group that owns the
repository are given write permission.

    git init --bare --shared=group repo.git

### Setup user for one or more git repos

Set user globally

    git config --global user.name "Foo Bar"
    git config --global user.email "foo@bar.com"

Set user for a single repo.

    git config user.name "Foo Bar"
    git config user.email "foo@bar.com"

Set password cache timeout:

    git config --global credential.helper 'cache --timeout=3600'

### Use a particular SSH key
Git can be told to use a particular SSH key:

    GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_example"

    # will now clone with the specified ssh command
    git clone git@github.com:some/repo.git

### Basic commands

On master: same as `git pull`

    git fetch && git merge origin/master

On master: same as `git pull --rebase`

    git fetch && git rebase origin/master

Avoid a merge commit if there are changes on master:

    git pull origin master --rebase


### Modifying global history

Revert a given commit. This adds a new "anti-commit" to the commit history.

    git revert <sha>


### Modifying local history
Recreate one or more files in your working directory as they were at that moment
in time, without altering history.

    git checkout <sha> -- <filename>

Undo some local (non-pushed) commits. `reset` rewinds your repository's history
all the way back to the specified SHA. By default, git reset preserves the
working directory. The commits are gone, but the content/modifications are
still on disk.  If you want to undo the commits _and_ the changes in one go:
use `--hard`.

    git reset <sha> [--hard]

While `git log'`shows the commit history, `reflog` shows when the tip of HEAD
changed. It contains entries like

    $ git reflog
    8409289 HEAD@{0}: commit: ufw cheat sheet
    94d334e HEAD@{1}: commit: skubectl alias
    ...

Reflog can be used to restore your local `HEAD` to a certain point in time.
To restore the project's history as it was at that moment in time:

    git reset --hard <sha>


### A simple Git workflow

Get repo

    git clone <repo-path> repo.git
    cd repo.git

Create a local branch.

    git checkout -b ticket123
    ... work on branch, commit, etc...

Add selected changes to commit:

    git add -p

To see, what changes you staged for commit, run

    git diff --staged

Commit:

    git commit -m "message"

Rebase from most recent master remote. `git rebase -i master` allows to squash
branch commits into a single commit for a cleaner commit history and/or change
commit messages.

    git checkout master
    git pull origin master --rebase
    git checkout ticket123
    git rebase [-i] master

Push local branch to remote origin server. `<localbranch>:<remotebranch>`

    git push origin ticket123:ticket1234

Merge with master branch and push to remote origin server.

    git checkout master
    git merge ticket123
    git push origin master:master


### Patching
Divide a large changeset into smaller commits. Git will now ask you, for each
hunk, if you want to stage it for the next commit. Answer `n` to all hunks you
don’t want to be part of the commit and `y` to hunks that you want to
include. Should a particular hunk contain both code that you want to include and
code that you don’t want to include, you can split it by selecting `s`. Git will
then split the hunk into smaller hunks and ask what to do with each of
them. Hunks for which you answered `n` will still be left as changes in
non-staged files.

    git add --patch <file>
    git add --patch

Produce an old-school patch with both staged and unstaged changes compared to
`HEAD`.

    git diff HEAD --no-prefix > patchfile

Apply patch.

    patch -p0 < patchfile

Produce a patch from an old commit
    git format-patch -1 <sha>
Show stats for patchfile.
    git apply --stat patchfile
Check for errors before applying.
    git apply --check patchfile
Apply patch
    git am < patchfile
OR apply patch using three-way merge (lets you resolve conflicts manually or
using git mergetool).
    git am -3 < patchfile


### Branches
List local branches:  `git branch`
List remote branches: `git branch -r`
Switch local branch:  `git checkout <otherbranch>`
Delete local branch:  `git branch -d ticket123`
Delete remote branch: `git push origin :ticket123
`
Rename local branch:

    # if on the branch to rename
    git branch -m use-package
    # if on a different branch than the one being renamed
    git branch -m old-name new-name
    # replace the old remote branch with the new
    git push origin :old-name new-name

Checkout a remote branch:
    git fetch && git checkout ticket123
    git fetch && git checkout -b x origin/x

Merge in branch updates from remote repository `origin` to your local copy of
the branch.

    git pull origin ticket123
    # don't create a merge commit
    git pull --rebase origin ticket123

Show all changes introduced on a branch that aren't on the master branch (`-p`
gives diffs in addition to commits).

    git log <branch> -p --not origin/master




### Rebasing
Rebase current branch onto the current head commit of the `master` branch. The
commits on this branch are replayed on top of `master`. NOTE: be careful, this
creates new commits (with new sha-1 hashes).

    git rebase master

So if you have pushed your branch to remote you will be warned that you're
behind your remote (since your commits have new ids). Run push with `--force` to
force an overwrite of the remote branch

    git push origin <mybr> --force-with-lease

Then ensure your colleagues do `git pull origin <mybr> --rebase`.

Rebase the `client` branch on `master`, only replaying the patches from the
`client` since it diverged from the `server` branch. So, this rebases `client`
on the `master` branch with commits "client - server".

    git rebase --onto master server client


### Tags

Show tags (on current local branch):
    git tag

Tag the latest commit (on current local branch):
    git tag -a v1.0.0 -m 'version 1.0.0'

Share the tag by pushing it to the remote repository (by default the git push
command doesn’t transfer tags to remote servers, you have to explicitly push
tags to a shared server after you have created them).
    git push origin v1.0.0

Remove a tag (for example, to re-do a broken release) in the remote repository.
    git push origin :v1.0.0

Remove a tag (for example, to re-do a broken release) in the local repo.
    git tag -d v1.0.0



### Submodules

Add a remote repo as a submodule.

    git submodule add <repo-url> <path>

Nicer looking submodule diffs (note: to make `--submodule` flag permanent, set
diff.submodule config for repo `git config --global diff.submodule log`):

    git diff --submodule

Cloning a repo with submodules.

    git clone --recursive <repo>

Alternatively:

    git clone <repo> && git submodule init && git submodule update

Bring in upstream (and optionally keep) changes in a particular submodule.

    cd <submodule-dir> && git fetch \
    [&& git merge origin/master]

Fetch and merge upstream changes (from origin/master) for _all_ submodules.

    git submodule update --remote

### Miscellaneous
Show info about the remotes of this repo.

    git remote -v

Show a short hash (like `ceba11f`) for current commit:

    git rev-parse --short HEAD

### Remove sensitive files

If a file containing sensitive data has been mistakenly added (and pushed)
history can be rewritten to exclude the file as described here:

  https://help.github.com/articles/removing-sensitive-data-from-a-repository/