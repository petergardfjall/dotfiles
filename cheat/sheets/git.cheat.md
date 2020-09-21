# About
Git is a distributed version-control system.

The major difference between Git and many earlier VCSs (cvs, svn, bzr) lies in
storage. Whereas predecessors often tracked changes made to each file over time
(deltas), git thinks of its data as a series of snapshots of a miniature
filesystem. With every commit, `git` stores a snapshot of the entire project and
stores a reference to that snapshot (with some cleverness to not duplicate file
storage like linking rather than copying when a file hasn't changed).

Git is *distributed* rather than *centralized*, giving every developer a full
copy (clone) of the repository. Therefore, most operations in Git need only
local files and resources to operate, with only occasional copying to a "more
central" repo. This differs from centralized client-server approaches which
require a much more chatty conversation with the server.

Git is designed with integrity in mind and uses sha-1 checksum hashes
extensively. History is stored in such a way that the id of every commit depends
upon the complete development history leading up to that commit.

When a commit is made Git stores a commit object that contains a pointer to the
snapshot of the content you staged. This object also contains the author's name
and email address, the message that you typed, and pointers to the commit or
commits that directly came before this commit (its parent or parents): zero
parents for the initial commit, one parent for a normal commit, and multiple
parents for a commit that results from a merge of two or more branches.


# States
Until a git file is added to version control it is *untracked*.

For *tracked files* (ones that git has been made aware of) a file in git can be
in one of three states:

- *modified*: a changed, but not yet commited file in your *working tree* (a
  checkout of one version of the repository).
- *staged*: a modified file that's been marked to go into the next commit. These
  are stored in the *staging area* file (`.git/index`).
- *committed*: stored in the local database.

The `.git` directory holds the repository (its metadata and object database) and
is what is copied when you `clone` the repo.

The basic workflow is: modify files in working tree > stage changes >
commit. The commit takes the files in the staging area and stores the snapshot
as a commit in the `.git` directory.

Git as a system manages and manipulates three trees in its normal operation:

- `HEAD`: points at the last commit snapshot, which will become the next parent
- *Index*: the proposed next commit snapshot
- *Working tree*: the sandbox with ongoing modifications


# Concepts

- *repository*: a collection of refs together with an object database containing
  all objects which are reachable from the refs.

- *bare repository*: a directory only containing the administrative files
  (`.git` directory) without a locally checked-out working tree.

- *commit*: a single point in the Git history; the entire history of a project
  is represented as a set of interrelated commits. Also used as a short hand for
  *commit object*.

- *commit object*: An *object* which contains the information about a particular
  revision (e.g. parents, committer, author, date and, a pointer to the
  top-level *tree object* of the stored revision -- the snapshot content).

- *commit-ish*: a commit object or an object that can be recursively
  dereferenced to a commit object. E.g. a commit object, a tag object that
  points to a commit object, a tag object that points to a tag object that
  points to a commit object, etc.

- *object*: the unit of storage. It is uniquely identified by the SHA-1 of its
  contents and, consequently, cannot be changed. Can be of type "commit",
  "tree", "tag" or "blob" (file).

- *tree object*: a directory. Contains a list of file names and modes along with
  refs to the associated blob and/or tree objects.

- *head*: a pointer (named reference) that tracks the tip of a branch. Heads are
  stored in a file in `.git/refs/heads/` (like `.git/refs/heads/master`).

- *HEAD*: a pointer to the local branch you're currently on (and its latest
  commit). This is how `git` knows what branch you're currently on. Stored in
  `.git/HEAD`. HEAD is a reference to one of the *heads* in your repository,
  except when using a *detached HEAD*, in which case it directly references an
  arbitrary commit.

- *detached HEAD*: what we end up with when checking out an arbitrary commit,
  not at the tip of any particular branch.

- *branch*: a lightweight movable pointer to a commit. Represents an active line
  of development. The most recent commit on a branch is referred to as the tip
  of that branch. The tip of the branch is referenced by a branch *head*, which
  moves forward as additional commits are made on the branch. A Git repo can
  track any number of branches, but your *working tree* is associated with just
  one of them (the "current" or "checked out" branch), and `HEAD` points to that
  branch. The default branch name in Git is `master`, since that's what `git
  init` produces.

- *tag*: a *ref* under `refs/tags` that points to a particular commit (or other
  tag).

- *ref*: A name that begins with `refs/` (e.g. `refs/heads/master`) that points
  to an object name or another ref (called a symbolic ref). For example, the
  `refs/heads/` hierarchy represents local branches.

- *remote (repository)* : a repository which is used to track the same project
  but resides somewhere else. To communicate with remotes, see *fetch* or
  *push*.

- *remote-tracking branch*: a *ref* (of form `origin/master`) used to follow the
  state of a remote repository branch. It typically looks like
  `refs/remotes/origin/master` (tracks branch `master` in remote
  `origin`). They're local references that you can't move; git moves them
  whenever you do any network communication,

- *upstream branch*: the default branch that is merged into the branch in
  question (on `git pull`).  If the upstream branch of `A` is `origin/B` we say
  that "A is tracking origin/B" or "A is a tracking-branch for origin/B". A
  tracking-branch is a local branch that has a direct relationship to a remote
  (upstream) branch.

- *git directory*: The `.git` directory is where git stores the metadata and
  object database for your project. This is the most important part of Git, and
  it is what is copied when you clone a repository from another computer.

- *working tree*: a single checkout of one version of the project. The working
  tree contains the contents of the `HEAD` commit's tree, plus any local changes
  that you have made but not yet committed.

- *index*: see *staging area* (or in older terminology: *index*)

- *staging area*: a file (`.git/index`) that stores information about what will
  go into your next commit

- *unreachable object*: an object which is not reachable from a branch, tag, or
  any other reference. It will eventually be garbage collected unless a
  reference is attached to it (like a tag or branch).

- *fast-forward*: a type of merge that just update the branch pointer to match
  the merged-in branch (only possible when the merged-in commit is a descendant
  of the current branch history, otherwise a *merge commit* is needed).

- *fetch*: fetching a branch means to get the branch's *head* ref from a
   *remote* repository. `git fetch` updates remote-tracking branches and tags
   from a remote.

- *pull*: pulling a branch means to *fetch* it and *merge* it.

- *merge*: to bring the contents of another branch (possibly from an external
  repository) into the current branch. Can either be *fast-forward* (if
  merged-in branch is a descendant) or result in a *merge-commit* having the
  tips of the merged branches as parents.

- *rebase*: to reapply a series of changes from a branch to a different base,
  and reset the head of that branch to the result.

- *push*: update *remote* refs using local refs.


# Configure
Check local/global settings:

    git config --list [--global]

Set user globally

    git config --global user.name "Foo Bar"
    git config --global user.email "foo@bar.com"

Set user for a single repo.

    git config user.name "Foo Bar"
    git config user.email "foo@bar.com"

Set password cache timeout:

    git config --global credential.helper 'cache --timeout=3600'


## Use basic auth for a repo
To configure that a particular user/password should be used for certain https
repos, one can use URL rewriting:

    git config --global url."https://${USER}:${ACCESS_TOKEN}@github.com/${PROJECT}".insteadOf "https://github.com/${PROJECT}"


## Use a particular SSH key
Git can be told to use a particular SSH key and port via an environment
variable:

    GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_example -p 2222"

    # will now clone with the specified ssh command
    git clone git@github.com:project/repo.git


# Creating a repo
An empty git repo (nothing but a `.git` directory) without any tracked files can
be created in a directory via:

    git init

One can also create a *bare repository* (only a `.git` directory) which is suitable for setting up a central repository (that is to act as remote for others). By convention its directory name should end with `.git`:

    git init --bare repo.git


# Cloning a repo
More commonly, a repository is cloned from a *remote* (repository).

    git clone https://github.com/project/repo.git repo

This creates a full replica (clone) of the remote repository locally, creates
remote-tracking branches for each remote branch, creates and checks out a local
branch that tracks the remote's default branch (`.git/HEAD` in the remote).

The currently checked out branch can be seen via:

    # also under .git/refs/heads/*
    git branch

The remote-tracking branches can be seen via:

    # also under .git/refs/remotes/*
    git branch -r


# Remotes
To support collaboration, a git repository can be set up to pull/push changes
from/to multiple other remote repositories.

List the remotes set up for the current repo:

    git remote -v

Show details about a particular remote (default branch, remote branches, etc):

    git remote show <remote>

Get a list of remote references (branches, tags, etc):

    git ls-remote

Additional remotes can be added/renamed/removed:

    git remote add upstream https://github.com/project/repo.git
    git remote rename origin main
    git remote remove upstream

One can fetch changes from a remote, which retrieves changes and updates all
remote-tracking branches for the remote:

    # updates the head of all remote-tracking branches: <remote>/<branch>
    git fetch <remote>

    # also removes any remote-tracking branches no longer on the remote
    git fetch <remote> --prune

    # fetch for all remotes at once
    git fetch --all

Note that fetch only updates *remote-tracking branches*. Your local branches
remain untouched until you choose to merge in changes from the remote-tracking
branches.

    git fetch origin
    git checkout master

    # or git rebase origin/master
    git merge origin/master

To combine a `fetch` and `merge` one can use `pull` (if the current branch is
set up to track a remote branch).

    # produces a merge commit if the branches have diverged (otherwise
    # a fast-forward merge is possible)
    git pull

    # rewrites local commits onto the updated head (with new hashes).
    # this avoids a merge commit if the branches have diverged.
    git pull --rebase

When you want to share your changes, you push them upstream.

    git push origin master

If you want to push your `master` branch to your `origin` remote server. You
need write-access to the remote, and noone else must have pushed in the
meantime. If so, your push is rejected and you first need to merge/rebase their
changes with yours.

Some other useful commands on remotes:

- List all commits on all remote branches:

        git log --remotes --oneline

        git log --branches=* --oneline


# Making changes

To move files between the supported states (untracked, unmodified, modified,
staged) and working in your *local* repo, the following commands are commonly
used.

Check the status of your files:

    git status

Track new files:

    git add <path>

Selectively stage changes (interactive):

    git add -p

Remove files

    git rm [-rf] <path>

Rename paths

    git mv <old-path> <new-path>

To view differences:

    # view changes not yet staged
    git diff
    # view changes that have been staged (and will go into next commit)
    git diff --staged

    # view changes between two arbitrary commits: git diff <commit>..<commit>
    git diff HEAD~1..HEAD
    # changes between branches for a particular file
    git diff master..feature1 pkg/svc/service.go


Record with everything in the staging area in a new commit (snapshot revision),
and advance `HEAD`:

    git commit [-m message]

Show a short hash (like `ceba11f`) for current commit:

    git rev-parse --short HEAD


# Viewing history
The commit history is best viewed with `git log`.

    # show all commits (including author and commit message)
    git log

    # also show which files were modified
    git log --stat

    # include the patch (code change)
    git log -p

    # print each commit on a single line
    git log --oneline

    # show a graph view including all branches and tags (refs/*)
    git log --graph --oneline --all

    # only show commits that are enough to explain how the files that
    # match the specified paths came to be
    git log --oneline -- <path> ...
    git log -p -- README.md

    # limit log to a certain range of commits
    git log HEAD~3..HEAD

    # with custom format
    git log --pretty=format:"%h - %an, %ar : %s"

Show a particular version/commit of a file:

    git show commit|tag|branch   # general info about an object
    git show ${rev}:${path}
    git show somebranch:from/the/root/myfile.txt
    git show 6b312a3:test/test.py
    git show HEAD~2:test/test.py


# Undoing
A few words on undoing/modifying history. Rewriting your local repository
history (modifying/squashing commits, etc) is never a problem. Making changes to
global history is only a problem if others are collaborating on the same
branch. For example, a common way of working includes feature branches, which
are rebased and force-pushed (with new commit hashes) prior to merge with
`master`. In such cases, community conventions (such as considering feature
branches private) are needed to avoid problems.

## Add to commit
Add more changes to a commit: `git commit --amend`

    # redo commit with changes staged since the commit was made
    git commit --amend

## Unmodifying a modified file
A file that is modified in the working tree, but not yet staged, can be brought
back to its unmodified state (`HEAD`) via

    git checkout [-p] [treeish] [--] <path>

For example:

    # 2.txt is now modified
    ${EDITOR} files/2.txt

    # undo changes: replace with most recently committed version
    git checkout -- files/2.txt
    # ... or equivalently
    git checkout HEAD -- files/2.txt

    # selectively undo things
    git checkout -p -- files/2.txt

It is also possible to recreate one or more files in your working directory as
they were at a given point in time, without altering history.

    # files/2.txt is checked out and staged as it looked one commit ago
    git checkout HEAD~1 -- files/2.txt
    # unstage: now it's in modified state (locking as it did one commit ago)
    git reset files/2.txt

## Undo staged files
Unstage staged files with `git reset [treeish] [path ...]` (the unstaged files
will still be *modified* in the working tree, so this is not destructive,
changes are preserved).

    # stage both 1.txt and 2.txt
    git add files/{1,2}.txt

    # unstage a particular file
    git reset HEAD files/1.txt
    # ... or equivalently
    git reset files/1.txt

    # unstage all changes
    git reset HEAD
    # ... or equivalently
    git reset

## Undo local commits
One can undo several local (non-pushed) commits with `reset`. It rewinds your
repository's history all the way back to the specified commit. By default, git
reset preserves the working directory. The commits are gone, but the
content/modifications are still on disk.  If you want to undo the commits _and_
the changes in one go: use `--hard`.

    git reset <tree-ish> [--hard]

    # reset repo to three commits back (keeping current changes in working tree)
    git reset HEAD~3

    # reset repo to a certain commmit (keep changes in working tree)
    git reset abc123a

Reset to a particular point in time with `git reset --hard` (note: this is
destructive, any local changes are cleared). Commits can still be found (via
`git reflog`) and reached (until garbage collected).

    git reset --hard <tree-ish>

    # reset repo to a certain commmit (warning: discards changes)
    git reset abc123a --hard

While `git log` shows the commit history, `reflog` shows when the tip of `HEAD`
changed and where it has been for the last few months. Think of the reflog as
Git's version of shell history. It contains entries like:

    $ git reflog
    8409289 HEAD@{0}: commit: ufw cheat sheet
    94d334e HEAD@{1}: commit: skubectl alias
    ...

Reflog can be used to restore your local `HEAD` to a certain point in time.
To restore the project's history as it was at that moment in time:

    git reset --hard <sha>

List all git commits mentioned in the `reflog` (the reflogs holds references to
all the commits you've used for the last 60 days by default):

     git log --reflog
     git log --reflog --graph --all --oneline

Expire unreachable commits in the reflog and then garbage collect them:

    git reflog expire --expire-unreachable=now --all
    git gc --prune=now


## Changing multiple commits
To change/rearrange/squash multiple commits, one typically makes use of an
interactive rebase (`git rebase -i <rebase-commit>`). With the interactive
rebase tool, you can then stop after each commit you want to modify and change
the message, add files, or do whatever you wish.

For example, to squash the last three commits into one:

    git rebase -i HEAD~3
    # > in the editor, select 's' (squash) for the last two commits and save
    # > fill in a new commit message and save

    # *alternatively*, `git reset` can be used to squash commits:
    git reset HEAD~3
    git add --all
    git commit -m "squashed commit"

As another example, if you have a sequence of commits but realize that your
latest commit belongs in an older commit, you can apply your current changes to
the prior commit as follows:

    # if the old commit to update is three commits back
    git rebase -i HEAD~3
    # this opens a rebase editor: mark the last commit and move up
    # two steps, then select 's' (squash) and save

To modify the third to last commit:

    git rebase -i HEAD~3
    # opens rebase editor: select 'e' (edit) for the first commit
    # modify
    git add <file> ...
    # amend the commit with the changes
    git commit --amend --no-edit
    # rewrite the rest of the commits on top of the new one
    git rebase --continue

## Undo an already pushed commit
Reverts a given commit by adding a new "anti-commit" to the commit history.

    git revert <sha>

## Remove sensitive data from repo
If a file containing sensitive data has been mistakenly added (and pushed)
history can be rewritten to exclude the file via `git filter-branch`:

  https://help.github.com/articles/removing-sensitive-data-from-a-repository/


# Branches
A branch in Git is simply a lightweight movable pointer to a commit. It's
actually a simple file that contains the 40 character SHA-1 checksum of the
commit it points to, so branches are cheap to create and destroy.

Listing branches:

    # show checked out branch (.git/HEAD)
    git branch --show-current

    # list local branches
    git branch

    # list remote branches
    git branch -r

Creating branches (`git branch <branchname> [branch/tag/commit]`):

    # create branch a branch pointing to HEAD
    git branch ticket123

Switching branches:

    # switch local branch
    git checkout <otherbranch>

Create and switch:

    # create (at HEAD) and switch
    git checkout -b ticket123

Deleting branches:

    # delete local branch
    git branch -d ticket123

    # delete remote branch (removes the server's ref/heads/ticket123 pointer)
    # note: the server will generally keep the data there for a while until
    # a garbage collection runs, so if it was accidentally deleted, it's
    # often easy to recover.
    git push origin :ticket123

Renaming branches:

    # if on the branch to rename
    git branch -m use-package
    # if on a different branch than the one being renamed
    git branch -m old-name new-name
    # replace the old remote branch with the new
    git push origin :old-name new-name

## Remote branches
*Remote-tracking branches* are references to the state of remote
branches. They're local references that you can't move; Git moves them for you
whenever you do any network communication. Remote-tracking branch names take the
form `<remote>/<branch>` (like `origin/master`). `git fetch origin` synchronizes
with a given remote by fetches data from it and moving your `origin/master`
pointer to its new, more up-to-date position.

When you want to share a branch with the world, you need to push it up to a
remote to which you have write access.

    git checkout ticket123
    git push origin ticket123

    # equivalently:
    # "Take my ticket123 local branch and push it to update the remote's
    # ticket123 branch."
    git push refs/heads/ticket123:refs/heads/ticket123

The next time collaborators `fetch`es from the server, they will get a reference
to where the server's version of `ticket123` is under the remote branch
`origin/ticket123`. Note that when you do a fetch that brings down new
remote-tracking branches, you don't automatically have local, editable copies of
them. That is, in this case, you don't have a new `ticket123` branch - only a
`origin/ticket123` pointer that you can't modify. To get your own `ticket123`
branch to work on, you can base it off your remote-tracking branch to create a
local *tracking branch* (tracking an *upstream branch*). For a tracking branch
`git pull` automatically fetches from the right remote branch.

    # create a "tracking-branch"
    git checkout -b ticket123 origin/ticket123
    # equivalently
    git checkout --track origin/ticket123

    ...
    # fetches (and merges) from origin/ticket123
    git pull

When cloning from a repository, git automatically sets up a `master`
tracking-branch with `origin/master` as upstream.

The tracked branch for a local can be (re)set at any time via:

    # -u or --setup-upstream-to
    git branch -u origin/ticket123

To get

## Merging and rebasing
A *merge* bring the contents of another branch into the current branch. A merge
can be either *fast-forward* (if merged-in branch is a descendant) or result in
a *merge-commit* having the tips of the merged branches as parents.

A fast-forward commit just update the branch pointer to match the merged branch:
when merged-in commit is a descendant of current branch history:

    #        master
    #          |
    #          V
    #  A - B - C - D - E <- ticket123 <- HEAD
    #
    git checkout master
    git merge ticket123
    #
    #                master <- HEAD
    #                  |
    #                  V
    #  A - B - C - D - E <- ticket123


A merge commit is performed when histories have diverged. git will try to do a
(three-way merge). This may result in a conflict which first must be resolved:


    #    D - E - F  <- ticket123 <- HEAD
    #   /
    #  A - B - C <- master
    #
    git checkout master
    git merge ticket123
    #
    # merge commit G
    #    D - E - F  <- ticket123
    #   /         \
    #  A - B - C - G <- master <- HEAD

A *rebase takes all the changes that were committed on one branch and replays
them on another branch. Rebasing makes for a cleaner history. If you examine the
log of a rebased branch, it looks like a linear history: it appears that all the
work happened in series, even when it originally happened in parallel.

    git checkout ticket123
    # rebase current branch onto the current `HEAD` commit of the `master`
    # branch. NOTE: the branch commits are assigned new sha-1 hashes!
    git rebase master
    #
    #          master
    #            |
    #            V
    #    A - B - C - D' - E' - F' <- ticket123 <- HEAD

On `git push` you will be warned that you're behind your remote (since your
commits have new hashes). Run push with `--force` to force an overwrite of the
remote branch

    git push origin ticket123 --force-with-lease

Then ensure your colleagues do `git pull origin ticket123 --rebase`.

To see which branches are (not) already merged into a given branch use:

    # see which branches are (not) already merged into master
    git branch --merged master
    git branch --no-merged master

Show all changes introduced on a branch that aren't on the master branch (`-p`
gives diffs in addition to commits).

    git log ticket123 -p --not master

## Rebase a selected range of commits
Generally speaking, to take some commits on a branch and rebase them onto the
tip of a different branch `git rebase --onto` can be used. For example,

    git rebase --onto=<new-base-branch> <commit-a> <commit-b>

This will take the range of commits `(commit-a, commit-b]` (that is, excluding
`<commit-a>` and replay on the `HEAD` of `<new-base-branch>`. Note that
`<commit-a>` and `<commit-b>` can be replaced with a branch name, which
translates to the `HEAD` commit of each branch.

For example, rebase the `client` branch on `master`, only replaying the patches
from the `client` since it diverged from the `server` branch. So, this rebases
`client` on the `master` branch with commits "client - server".

    git rebase --onto master server client

# Resolving conflicts
Whenever a `git rebase` is made, there is a risk of conflicting modifications.
Normally, you would go through conflicts one-by-one, fix them, do `git add` or
`git rm`, and finally `git rebase --continue`.

In some cases you know that you want to resolve in favor of your changes (or
don't care). In such cases, a conflicting file can be resolved via:

    git checkout --theirs go.sum   # resolve in favor of your changes
    git checkout --ours   go.sum   # resolve in favor of their changes

Note that the direction is reversed on `rebase` when compared to `merge` (where
`ours` really means our changes). On `rebase`, `ours` refers to the anonymous
rebase branch that the rebase is built on.


# Tags
Show tags:

    git tag

Add a lightweight tag (a lightweight tag is very much like a branch that doesn't
change — it's just a pointer to a specific commit):

    git tag v1.0.0
    # equivalently
    git tag v1.0.0 HEAD

    git tag v1.0.0 abc123a

Add an annotated tag (annotated tags are stored as full objects in the Git
database. They're checksummed; contain the tagger name, email, and date; have a
tagging message; and can be signed):

    git tag -a v1.0.0 -m 'version 1.0.0'
    git show v1.0.0

Publish the tag by pushing it to the remote repository

    git push origin v1.0.0
    #equivalently
    git push origin refs/tags/v1.0.0:refs/tags/v1.0.0

Remove a local tag:

    git tag -d v1.0.0

Remove a remote tag:

    git push origin :v1.0.0

When checking out a tag you end up in a "detached HEAD state". If you make
changes and then create a commit, the tag will stay the same, but your new
commit won't belong to any branch and will be unreachable, except by the exact
commit hash. To make changes (like fixing a bug on an older version) create a
branch from the tag:

    git checkout -b fix v1.0.0

Show any tags that are attached to current commit:

    git tag -l --points-at HEAD


# Typical workflow
Clone:

    git clone <repo-path> repo
    cd repo

Create a local branch (from `master`).

    git checkout -b ticket123
    ... work on branch, commit, etc...

Add selected changes to commit:

    git add -p

To see, what changes you staged for commit, run

    git diff --staged

Commit:

    git commit -m "message"

Rebase from most recent master remote. `git rebase -i master` allows to
modify/reorder/squash branch commits for a cleaner commit history and/or change
commit messages.

    git checkout master
    git pull origin master --rebase
    git checkout ticket123
    git rebase [-i] master

Push local branch to remote origin server.

    git push origin ticket123:ticket1234

Merge with master branch and push to remote origin server.

    git checkout master
    git merge ticket123
    git push origin master:master

While working on a local fork you may sometimes want to pull in changes from the
upstream repo:

    # assuming we're in our own fork ...
    $ git remote -v
    origin https://github.com/johndoe/projx.git (fetch)
    origin https://github.com/johndoe/projx.git (push)

    # add upstream repo as a remote
    $ git remote add upstream https://github.com/projx/projx
    $ git remote -v
    origin https://github.com/johndoe/projx.git (fetch)
    origin https://github.com/johndoe/projx.git (push)
    upstream https://github.com/projx/projx (fetch)
    upstream https://github.com/projx/projx (push)

    # fetch upstream changes
    $ git fetch upstream
    # rebase your changes on master onto the changes from upstream/master.
    $ git checkout master
    $ git rebase upstream/master


# Cleaning
 To remove all the untracked files in your working directory run:

     # removes files and also any subdirectories that become empty as a result.
     git clean -f -d --dry-run


# Patching
Divide a large changeset into smaller commits. Git will now ask you, for each
hunk, if you want to stage it for the next commit. Answer `n` to all hunks you
don't want to be part of the commit and `y` to hunks that you want to
include. Should a particular hunk contain both code that you want to include and
code that you don't want to include, you can split it by selecting `s`. Git will
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



# Submodules
Submodules allow you to keep a git repository as a subdirectory of another Git
repository. This lets you clone another repository into your project and keep
your commits separate.


Add a remote repo as a submodule. This creates a `.gitmodules` file that stores
all submodules in use. It provides the indirection to referenced repos and is
stored with your repo.

    git submodule add <repo-url> <path>

Nicer looking submodule diffs (note: to make `--submodule` flag permanent, set
diff.submodule config for repo `git config --global diff.submodule log`):

    git diff --submodule

Cloning a repo with submodules:

    git clone --recurse-submodules <repo>

    # equivalent
    git clone <repo> && git submodule init && git submodule update

Bring in upstream (and optionally keep) changes in a particular submodule.

    # you can work on the submodule repo (commit, fetch, push, ...)
    cd <submodule-dir> && git fetch
    git merge main origin/main
    git push origin main

    # then head back to the parent repo and include changes
    cd ..
    git add <submodule-dir>
    git commit -m "updated submodule version"


Fetch and merge upstream changes (from origin/master) for _all_ submodules.

    git submodule update --remote


# Referring to commits
Individual commits:

- If you place a `^` (caret) at the end of a reference, Git resolves it to mean
  the parent of that commit.
- The other main ancestry specification is the `~` (tilde). This also refers to
  the first parent, so `HEAD~` and `HEAD^` are equivalent. The difference
  becomes apparent when you specify a number. `HEAD~2` means “the first parent
  of the first parent,” or “the grandparent”. `HEAD~3` is equivalent to
  `HEAD~~~`.

Ranges of commits:

- `master..experiment` means "all commits reachable from experiment that aren't
  reachable from master". For example,

        # show commits in your current branch that aren't in the master
        # branch on your origin remote
        git log origin/master..HEAD


# git archive
Use `git archive` to create an archive/release from a given version of the
repository:

    git archive --format=tar.gz --prefix=root/ <tree-ish> [<path>...]
    git archive --format=tar.gz --prefix=head/ HEAD .



# Migrating a single file/directory (with history) to another repository
To take a file (with entire commit history) and move that to a new repository,
do something like:

    cd old-repo
    git log --pretty=email --patch-with-stat --reverse --full-index --binary -- path/to/file_or_folder > patch
    # might want/need to edit some patches
    ${EDITOR} patch
    cd ../new-repository
    git am --committer-date-is-author-date < ../old-repo/patch

Note that if the file was moved/renamed at some point the history will not
expand beyond that point.


# Internals
The `.git` directory is where almost everything that Git stores and manipulates
is located. If you want to back up or clone your repository, copying this single
directory elsewhere gives you nearly everything you need.

- `HEAD`: points to the branch you currently have checked out. This is how does
  Git know the SHA-1 of the last commit. Usually a symbolic reference to the
  branch you’re currently on.

- `index`: where Git stores your staging area information.
- `objects` directory: stores all the content for your database
- `refs` directory: stores pointers into commit objects in that data (branches,
  tags, remotes and more).
   - `heads`: local branches: `git branch test` creates a reference under
     `refs/heads/test`
   - `tags`: local tags (pointers to commits). It's like a branch reference, but
     it never moves - it always points to the same commit but gives it a
     friendlier name (`refs/tags/v1.0`).
   - `remotes`: stores the value you last pushed to/fetched from that remote for
      each branch (e.g. `refs/remote/origin/`) Remote references differ from
      branches (`refs/heads` references) mainly in that they're considered
      read-only. You can git checkout to one, but Git won't point HEAD at one,
      so you'll never update it with a commit command.
