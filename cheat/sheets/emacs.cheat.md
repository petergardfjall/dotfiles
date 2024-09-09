# Legend

- `M` = Meta (or Alt)
- `C` = Ctrl

# General

- Exit: `C-x C-c`

# Help

- Help: `C-h` (or `F1`)
- *A*propos: show matching commands `C-h a <match-string>`
- Describe function for *k*ey `C-h k <keyboard-shortcut>`
- Describe a *f*unction `C-h f`
- Get key *b*indings in buffer `C-h b` or `M-x describe-mode`
- Get *m*ode-specific information `C-h m`
- Display value and doc of *v*ar `C-h v var <RET>`

- List keyboard shortcuts: `M-x describe-bindings`
- List all personal keybindings: `M-x describe-personal-keybindings`
- Toggle line numbers: `M-x linum-mode`

- Customize/select theme: `M-x customize-themes`
- Customize variables and faces: `M-x customize`
- Set a customizable var: `M-x customize-set-variable <var>`

- Reload configuration: `M-x load-file ~/.emacs`

# Appearance

- Increase buffer font size: `C-x C-+`
- Decrease buffer font size: `C-x C--`

# Packages (package.el)

The built-in package manager is called `package.el` (alternatives such as
`straight.el` exist to gain tighter control over versioning).

- Refresh and list packages: `M-x list-packages`
- In package view, press `U` to mark all upgradable packages for upgrade, and
  `x` to perform the upgrades.

# Major Mode:

- Describe current major-mode: `M-x describe-mode`
- Set mode (e.g. `yaml-mode`): `M-x <mode>`

# File and buffers

- Open file: `C-x C-f`
- Save buffer: `C-x C-s`
- Save all: `C-x s`
- Kill/close frame: `M-x delete-frame`
- List buffers: `C-x C-b`
  - `d` to mark for _deletion_
  - `u` to _unmark_
  - `x` to _execute_ marked deletions
- Switch buffer: `C-x b <buffer>`
- Kill/close buffer: `C-x k`
- Restore buffer: `M-x revert-buffer`

# Multiple windows (in buffer)

- Split window: `C-x 2` (vertical) `C-x 3` (horizontal)
- Switch to other window: `C-x o`
- Close other windows: `C-x 1`
- Close this window: `C-x 0`

# Navigation

- One word forward: `M-f`
- One word backward: `M-b`
- One expression forward: `C-M-f` (jump to closing delimiter/parenthesis)
- One expression back: `C-M-b` (jump to opening delimiter/parenthesis)
- Start of buffer: `M-<`
- End of buffer: `M->`
- Start of line: `C-a`
- End of line: `C-e`
- Goto line: `M-g g`
- Save point to register: `C-x r <SPC> <name>`
- Jump to point in register: `C-x r j <name>`

# Editing

- Undo: `C-x u`
- Cancel/abort command: `C-g`
- Delete (rest of) row: `C-k`
- Delete (next) word: `M-d`
- Delete (previous) word: `M-Backspace`
- Delete selection/region: `C-w` or `M-x delete-region`
- Delete trailing whitespace: `M-x delete-trailing-whitespace`
- Insert `<str>` on each line `C-sp, move to row, C-x r t <str>`
- Break paragraph lines (@fillcol) `M-q`
- set-fill-column `C-x f <col>`
- Uppercase word at cursor `M-u`
- Lowercase word at cursor `M-l`
- Capitalize word at cursor `M-c`

_Rectangle_:

- Start rectangle corner at cursor: `C-space`
- Prefix each rectangle line with text: `C-x r t <chars>`
- Kill rectangle: `C-x r k`
- Copy rectangle `C-x r M-w`
- Yank rectangle: `C-x r y`

# Copy-paste

- Start selection: `C-Space`
- Select all: `C-x h`
- Copy (region): `M-w`
- Cut (region): `C-w`
- Insert another file: `C-x i`
- Paste (yank): `C-y`

# Indentation

- Indent rigidly (marked rows): `C-u C-x TAB`
- Decrease indent by 2: `C-u 2 C-x TAB`
- Decrease indent by 4: `C-u -4 C-x TAB`
- Mode-aware indent: `M-x indent-region`

# Search/replace

- Search forward: `C-s`
- Search backward: `C-r`
- Query replace: `M-%`
- Replace with regexp: `M-x query-replace-regexp`

# Bookmarks

- Set bookmark at point: `C-x r m`
- Jump to bookmark: `C-x r b`
- List bookmarks: `C-x r l`
- Delete bookmark: `M-x bookmark-delete`

# Shell/terminal

In a "shell" Emacs is used to edit a command-line: the shell sub-process doesn't
see any input until you press return. In a "terminal", each key-press is
captured by the subprocess.

There are may ways to open a subshell and run external commands. For example,
`term` (`ansi-term`), `shell`, `eshell`, and `vterm`. Each with some strengths
and limitations.

- `term` (built-in): terminal emulator that passes keys to the shell subprocess.
  - Does full terminal emulation.
  - Allows ncurses programs (`htop`) and cursor movement (`less`, `man`).
  - Can switch between the default `term-char-mode` (`C-c C-k`) where all input
    is captured by the shell, and `term-line-mode` (`C-c C-j`) which allows
    freely moving around (mark, copy, etc) like in a normal Emacs buffer.
- `ansi-term` (built-in): very similar to `term`.
- `vterm`: like `term` but better performance and supports more escape codes.

- `shell` (built-in): runs a sub-shell like `bash` with input and output going
  through the `*shell*` buffer.
  - The cursor can be moved freely within the `*shell*` buffer.
  - Input in the buffer (terminate by `RET`) gets sent to the shell.
  - Supports color codes.
  - No support for ncurses programs (`htop`) or cursor movement (`less`, `man`).
- `eshell` (built-in): a shell entirely written in Elisp.
  - Acts both as an elisp REPL and a shell-like interface.
  - Commands invoked either via (shell-like) command forms or lisp forms:
    - `echo hello` vs `(format "hello")`
  - Since it runs inside Emacs (no external process) it can be used to
    interact/script with the Emacs session. For example:
    - `$ cat file.txt >> #<buffer *scratch*>`
  - A command form can be either an external program or an elisp function.
  - Implements some GNU Coreutils commands in elisp (extra useful on Windows).
  - Programs that aren't line-oriented (like ncurses) will produce garbage.
    - `eshell-visual-commands` can be used to tell `eshell` which commands
      require a display. Such commands get passed to `term`.

# Shell commands

- Execute a shell command: `M-!`
- Open shell in `*shell*` buffer: `M-x shell`

# Web browser

- Open web page: `M-x eww <URL>`
- Reload web page: `M-x eww-reload`

# Lisp

Go to the _scratch_ buffer, enter an expression, like `(+ 1 1)`, and run `C-j`
to have the last expression evaluated.

# Concepts

Emacs' graphical layout has three primary concepts:

- _Frame_: a graphical window or terminal screen occupied by Emacs.
- _Window_: Occupies the main area of the frame and displays a single buffer. A
  frame can be split to display multiple windows.
- _Buffer_: the contents displayed in a frame. A buffer is commonly visiting a
  file.

- commands (interactive functions)

- modes:
  https://www.gnu.org/software/emacs/manual/html_node/emacs/Modes.html#Modes

- hooks TODO:
  https://www.gnu.org/software/emacs/manual/html_node/emacs/Hooks.html

- autoloads

TODO: https://www.emacswiki.org/emacs/AutoLoad

TODO: `auto-mode-alist`: https://www.emacswiki.org/emacs/AutoModeAlist TODO:
`interpreter-mode-alist`: https://www.emacswiki.org/emacs/InterpreterModeAlist

# Themes and faces

- `M-x load-theme <theme>`: load and apply a particular theme.
- `M-x customize-create-theme`: opens the theme customization tool that shows
  all basic faces that need to be filled out by a theme.
- `M-x customize-face <face>`: allows a particular editor face to be edited
  (default: `all faces` shows every face)
- `M-x list-faces-display`: list and customize faces.
- `M-x describe-face`: describe the face at point.
- `M-x describe-text-properties`: learn all faces being used at point: faces for
  overlays at point, face which in turn is a list of faces (as in org mode tags)

# Tramp-mode

`tramp` brings transparent access to files on remote hosts. `tramp` is triggered
by the name entered when opening a file.

    C-x C-f /remotehost:filename
    C-x C-f /method:user@remotehost:filename

When using `tramp` to edit a file on a remote host, `M-x shell` will
automtically invoke the remote shell.

Tab completion in the minibuffer works for hosts just like for files:

`C-x C-f` and then enter `/ssh:` and press `TAB`

via completion candidates from `~/.ssh/{config,known_hosts}`. The full list is
set in `tramp-completion-function-alist`.

You can also edit local files as `root` (note the double colon!)

    C-x C-f /su::/etc/hosts
    C-x C-f /sudo::/etc/hosts

You can even open files with a "multi-hop" syntax:

    C-x C-f /ssh:bird@bastion|ssh:you@remotehost:/path
    // open as root on remotehost. NOTE: remote host needs to be given!
    C-x C-f /ssh:you@remotehost|sudo:remotehost:/path/to/file RET

# Debugging

To make every `error` call dump a backtrace:

- `(setq debug-on-error t)`
- `M-x toggle-debug-on-error`)
- `emacs --eval '(setq debug-on-error t)' <file>`

# Org mode

Org mode is a plain text system for keeping notes, maintaining to-do lists,
planning, scheduling and even authoring. In short, a mode for organizing life.

It's implemented on top of _outline mode_, a mode specialized at managing
(editing, navigating, visibility-cycling) tree-structured content.

_Headings_ are marked with leading asterisks `*`, with a deeper (sub)heading in
the tree indicated by one more leading asterisk. Text under each heading is
called the _body_, and together a heading and a body forms an _entry_.

Outline-mode:

- `TAB`/`org-cycle`: local visibility cycling over states `FOLDED`, `CHILDREN`,
  `SUBTREE`
- `S-TAB`/`org-global-cycle`: global visibility cycling over states `OVERVIEW`,
  `CONTENTS`, `SHOW ALL`
- `M-RET`/`org-meta-return`: insert new heading at current heading level
  - `TAB`/`org-cycle`: cycle level in a new entry (each press demotes one level)
- `M-S-RET`/`org-insert-todo-heading`: insert `TODO` heading at current level
- `M-left`/`org-do-promote`: promote current entry one level
- `M-right`/`org-do-demote`: demote current entry one level
- `M-S-left`/`org-promote-subtree`: promote current subtree one level
- `M-S-right`/`org-demote-subtree`: demote current subtree one level
- `M-up`/`org-move-subtree-up`: move subtree up before prior entry
- `M-down`/`org-move-subtree-down`: move subtree down after next entry
- `C-c C-,`/`org-insert-structure-template`: insert structural blocks, such as
  `#+BEGIN_SRC...#+END_SRC`. Within an outline tree, one can also add lists to
  entry bodies.
- _Unordered lists_ start with `-`, `+` or `*`
- _Ordered lists_ start with `1.` or `1)`

TODOs:

- `C-c C-t`/`org-todo`: rotate the `TODO` state
- `S-left`/`S-right`: select following/preceding `TODO` state
- `S-up`/`org-priority-up`
- `S-down`/`org-priority-down`

Table editor:

- `C-c |`: create an org table
- `C-c C-c`/`org-table-realign`: re-align table at point
- `TAB`/`org-table-next-field`: re-align, move to next field
- `S-TAB`/`org-table-previous-field`: re-align, move to prev field
- `M-left`/`org-table-move-column-left`
- `M-right`/`org-table-move-column-right`
- `M-up`/`org-table-move-row-up`
- `M-down`/`org-table-move-row-down`
- `M-S-left`/`org-table-delete-column`: kill current column
- `M-S-right`/`org-table-insert-column`: insert new column
- `M-S-up`/`org-table-kill-row`: kill current row
- `M-S-down`/`org-table-insert-row`: insert new row
- `S-<cursors>`: move cell by swapping with adjacent cell
- `C-c +`/`org-table-sum`: echo sum of numbers in column (`C-y` yanks)
- note: the table editor can be enabled in other modes via `orgtbl-mode`

Links:

- link format: `[[LINK][DESCRIPTION]]` or `[[LINK]]`
- schemes: `file`, `mailto`, `help`, `http(s)`, `shell`, etc.
- without scheme, a link refers to the current doc: e.g. `[[*Some section]]`
- `C-c o l`/`org-store-link`: (note: custom global key-binding) stores a link to
  thing at point for later insertion. Link format depends on where call is made.
- `C-c C-l`/`org-insert-link`: used in org buffers. Semantics depend on context:
  - When point is on a link, edit link.
  - Otherwise, prompt for previously stored link to be inserted.
- `C-c C-o`/`org-open-at-point`: follow link.

Capture:

- `C-c o c`/`org-capture`: (note: custom global keybinding)

Agenda view:

- `C-c o a`/`org-agenda`: (note: custom global keybinding)
- `S-f`: follow mode: agenda item under cursor highlighted in org buffer
- `f`/`b`: move forward or backward one time unit (a week)
- `q`: exit agenda view

## Scheduling and deadlines:

# use-package

The primary purpose of `use-package` is to configure and (lazily) load Emacs
packages. It interfaces with package managers, which allows it to also ensure
that packages are installed before use.

Thanks to the lazy/on-demand loading of packages it enables, it typically helps
reduce the startup time of Emacs. Behind the scenes `use-package` makes use of
Emacs' `autoload` facility, which lets you register the existence of a function
or macro, but put off loading the file that defines it. The first call to the
function automatically loads the proper library, in order to install the real
definition and other associated code, then runs the real definition as if it had
been loaded all along.

    autoload function filename &optional docstring interactive type

For example,

    (autoload 'ace-jump-mode "ace-jump-mode.el" nil t)

## Configuration

Use the `:init` keyword to execute code _before_ a package is loaded. It accepts
one or more forms, up to the next keyword:

    (use-package foo
      :init
      (setq foo-variable t))

Since `:init` is always run, even when the package is configured to be loaded
lazily (deferred), one should restrict this to (1) code that doesn't rely on the
package being loaded and (2) avoid time-consuming calls (since they would be
executed on _every_ emacs start, no matter if we actually _need_ the package).

Similarly, `:config` can be used to execute code _after_ a package is loaded. In
cases where loading is done lazily, this execution is deferred until after the
autoload occurs:

    (use-package foo
      :init
      (setq foo-variable t)
      :config
      (foo-mode 1))

## Lazy (deferred) loading

`use-package` can defer loading of a module until a certain command is invoked.

    (use-package company-lsp
      ;; download the package via package.el if it's not available
      :ensure t
      ;; autoload the package whenever `(company-lsp)` is invoked.
      :commands company-lsp

When you use the `:commands` keyword, it creates `autoload`s for those commands
and defers loading of the package until any command is invoked. The `:commands`
keyword takes either a symbol or a list of symbols.

One can combine the use of `:command` with binding a keyboard shortcut to the
command that will trigger the module to be loaded:

    (use-package ace-jump-mode
      :bind ("C-." . ace-jump-mode))

This does two things: first, it creates an autoload for the `ace-jump-mode`
command and defers loading of `ace-jump-mode` until the command is invoked.
Second, it binds the key `C-.` to that command. After loading, you can use
`M-x describe-personal-keybindings` to see all such keybindings you've set
throughout your .emacs file.

A more literal way to do the exact same thing is:

    (use-package ace-jump-mode
      :commands ace-jump-mode
      :init
      (bind-key "C-." 'ace-jump-mode))

Or, an _even more_ verbose way of achieving the same thing:

    (use-package ace-jump-mode
      :defer t
      :init
      (autoload 'ace-jump-mode "ace-jump-mode" nil t)
      (bind-key "C-." 'ace-jump-mode))

Note: `:defer t` is implied whenever `:commands`, `:bind`, `:mode`,
`:interpreter` or `:hook` are used.

## Lazy loading via modes and interpreters

Similar to `:commands` and `:bind`, you can use `:mode` and `:interpreter` to
establish a deferred binding within the `auto-mode-alist` and
`interpreter-mode-alist` variables. The specifier to either keyword can be a
cons cell, a list of cons cells, or a string or regexp:

    (use-package ruby-mode
      ;; load if file ends in .rb
      :mode "\\.rb\\'"
      ;; load if file contains a ruby shebang such as `#!/usr/bin/env ruby`
      :interpreter "ruby")

    ;; The package is "python" but the mode is "python-mode":
    (use-package python
      ;; load if file ends in .py
      :mode ("\\.py\\'" . python-mode)
      ;; load if file contains a python shebang such as `#!/usr/bin/env python`
      :interpreter ("python" . python-mode))

## Lazy loading via hooks

The `:hook` keyword allows adding functions onto hooks, here only the basename
of the hook is required. Thus, all of the following are equivalent:

    (use-package ace-jump-mode
      :hook (prog-mode text-mode))

    (use-package ace-jump-mode
      :hook ((prog-mode text-mode) . ace-jump-mode))

    (use-package ace-jump-mode
      :hook ((prog-mode . ace-jump-mode)
             (text-mode . ace-jump-mode)))

    (use-package ace-jump-mode
      :commands ace-jump-mode
      :init
      (add-hook 'prog-mode-hook #'ace-jump-mode)
      (add-hook 'text-mode-hook #'ace-jump-mode))

When using `:hook` omit the "-hook" suffix if you specify the hook explicitly,
as this is appended by default.

Multiple hooks can trigger loading of a package:

    (use-package ace-jump-mode
      :hook (prog-mode text-mode))

    (use-package ace-jump-mode
      :hook ((prog-mode text-mode) . ace-jump-mode))

    (use-package ace-jump-mode
      :hook ((prog-mode . ace-jump-mode)
             (text-mode . ace-jump-mode)))

The use of `:hook`, `:bind`, `:mode`, `:interpreter`, etc., causes the functions
being hooked to implicitly be read as `:commands` (meaning they will establish
interactive `autoload` definitions for that module, if not already defined as
functions), and so `:defer t` is also implied by `:hook`.

## Notes about lazy loading

In almost all cases you don't need to manually specify `:defer t`. This is
implied whenever `:bind` or `:mode` or `:interpreter` is used. Typically, you
only need to specify `:defer` if you know for a fact that some other package
will do something to cause your package to load at the appropriate time, and
thus you would like to defer loading even though `use-package` isn't creating
any autoloads for you.

You can override package deferral with the `:demand` keyword. Thus, even if you
use `:bind`, using `:demand` will force loading to occur immediately and not
establish an autoload for the bound key.

`:defer [N]` causes the package to be loaded -- if it has not already been --
after `N` seconds of idle time. This can be used to unconditionally load many
packages while still having a rapid startup.

## Conditional loading

You can use the `:if` keyword to predicate the loading and initialization of
modules.

    (use-package edit-server
      :if window-system
      :init
      (add-hook 'after-init-hook 'server-start t)
      (add-hook 'after-init-hook 'edit-server-start t))

The `:disabled` keyword can turn off a module you're having difficulties with,
or stop loading something you're not using at the present time:

    (use-package ess-site
      :disabled
      :commands R)

A package can also be triggered to load after another package via `:after`:

    :after (foo bar)
    :after (:all foo bar)
    :after (:any foo bar)
    :after (:all (:any foo bar) (:any baz quux))
    ;; load when either both foo and bar have been loaded, or
    ;; both baz and quux have been loaded
    :after (:any (:all foo bar) (:all baz quux))

## Package installation

You can use use-package to load packages from ELPA with `package.el`. This is
particularly useful if you share your .emacs among several machines; the
relevant packages are downloaded automatically once declared in your .emacs. The
`:ensure` keyword causes the package(s) to be installed automatically if not
already present on your system (set `(setq use-package-always-ensure t)` if you
wish this behavior to be global for all packages):

    (use-package magit
      :ensure t)

Note that `:ensure` will install a package if it is not already installed, but
it does not keep it up-to-date.

By default package.el prefers `melpa` over `melpa-stable` due to the versioning
`(> evil-20141208.623 evil-1.0.9)`, so even if you are tracking only a single
package from melpa, you will need to tag all the non-melpa packages with the
appropriate archive.

One can use `:pin` to pin a certain package to a certain archive.

    (use-package company
      :ensure t
      :pin melpa-stable)

## Local packages

If your package needs a directory added to the load-path in order to load, use
`:load-path`. This takes a symbol, a function, a string or a list of strings. If
the path is relative, it is expanded within `user-emacs-directory`:

    (use-package ess-site
      :load-path "site-lisp/ess/lisp/"
      :commands R)

## Key-bindings

As mentioned above, one can set up a (deferred) autoload of a package for a
certain command and also bind that command to a key-binding via:

    (use-package org
      ...
      :bind (("C-c o o" . my-org-open)
             ("C-c o l" . org-store-link)
             ("C-c o c" . org-capture)
             ("C-c o a" . org-agenda))
      ...

One can also use `:bind` to set up custom key-bindings _within_ a local keymap
that only exists after the package is loaded via a `:map` modifier:

    (use-package org
      ...
      :bind (("C-c o o" . my-org-open)         ;; global, auto-loading command
             :map org-mode-map                 ;; local key-bindings after load
             ("C-c o x" . org-archive-subtree)
             ("C-c o >" . org-clock-in)
             ("C-c o <" . org-clock-out)
      ...

The effect of the `:map` statement is to wait until `org-mode` has loaded, and
then to bind e.g. `C-c o x` to `org-archive-subtree` within org-mode's local
keymap, `org-mode-map`. Something similar can also be achieved via:

(define-key projectile-mode-map (kbd "C-c s p") 'counsel-projectile-ag)

    (use-package org
      ...
      :bind (("C-c o o" . my-org-open))
      :config
      (define-key org-mode-map (kbd "C-c o x") 'org-archive-subtree)
      ...

# straight-el (package manager)

The biggest benefit of `straight.el` over the built-in `package.el` is that
`straight.el` supports 100% reproducibility for your Emacs packages with version
lockfiles.

- It uses git to store/update package sources (`~/.emacs.d/straight/repos`).
- Editing packages locally is trivial (as is upstreaming patches). Just edit
  files in place. Packages are rebuilt if necessary when Emacs restarts.
- You are free to commit your changes and push or pull to various remotes using
  Git.
- A version lockfile can be written to `~/.emacs.d/straight/versions/default.el`
  if you want reproducibility of your Emacs environment between hosts. This
  should be kept under version control.

- `M-x straight-pull-package/straight-pull-all`: fetch/merge upstream changes
  from each package's configured remote.
- `M-x straight-remove-unused-repos`: clear out packages not mentioned in init
  file.
- `M-x straight-check-package/straight-check-all`: force rebuild of package(s).

- `M-x straight-freeze-versions`: save the currently checked out revisions of
  all of your packages
- `M-x straight-thaw-versions`: revert all packages to the revisions specified
  in the lockfile.

One can always perform rebuild (if needed) with M-x straight-check-package or
M-x straight-check-all.

# Custom keybindings

Navigation:

- `C-x w <arrow>`: `windmove-{up|down|left|right}` (move between windows) Window
  management hydra:
- Prefix: `C-c C-w`
  - `<arrow>`: `windmove-{up|down|left|right}`
  - `S-<up|down>`: `enlarge-window|shrink-window` (on v-split win)
  - `S-<left|right>`: `{enlarge|shrink}-window-horizontally` (on h-splits win)

Text size:

- `C-x C-+`: `default-text-scale-increase`
- `C-x C--`: `default-text-scale-decrease`
- `C-x C-0`: `default-text-scale-reset`

File explorer:

- `F8`: `toggle-treemacs`

Formatting:

- `C-c c`: `comment-line`
- `C-c w`: `delete-trailing-whitespace`

General find definition of thing at point (if supported by mode):

- `M-<down>`: `xref-find-definitions`
- `M-<up>`: `xref-pop-marker-stack`
- `C-c f d`: `xref-find-definitions`
- `C-c f r`: `xref-find-references`
- `C-c C-d`: `describe-symbol` (any docs for thing at point?)

Find file (in project)

- `C-c f f` `project-find-file`

Undo:

- `C-x u`: `undo`
- `C-z`: `undo-tree-undo`
- `C-Z`: `undo-tree-redo`
- `C-c u t` `undo-tree-visualize` (show undo tree: select state and press 'q')

Auto-completion:

- `C-<tab>` `company-complete`

Show errors in current buffer:

- `C-c s e`: `list-flycheck-errors`

"Find type" ("find tag"), requires `gtags` to have been run on project.

- `C-c f t`: `ggtags-find-definition`

Free-text search (via ag/silversurfer):

- `C-c s p`: `counsel-projectile-ag` ("search-in-project")

Language Server Protocol interactions:

- `<M-down>` `lsp-find-definition`
- `<M-up>` `xref-pop-marker-stack`
- `C-c p d` `lsp-ui-peek-find-definitions`
- `C-c p r` `lsp-ui-peek-find-references`
- `C-c h` `lsp-document-highlight`
- `C-c f d` `lsp-find-definition`
- `C-c f i` `lsp-goto-implementation`
- `C-c f r` `lsp-find-references`
- `C-c C-r` `lsp-rename`
- `C-c C-d` `lsp-describe-thing-at-point`
- `C-c d` `lsp-ui-doc-show`
- `C-c e` `lsp-ui-doc-hide` ("end doc show")

Snippets:

- `<type trigger><TAB>`: expand snippet
- `M-x yas-describe-tables`: show available snippets

Markdown-mode:

- `C-c p m` `markdown-preview-mode`

Org-mode:

- Global:
  - `C-c o o`: open a file in my `~/org`.
  - `C-c o l`: `org-store-link`
  - `C-c o c`: `org-capture`
  - `C-c o a`: `org-agenda`
- In an org-mode buffer
  - `C-c o x`: `org-archive-subtree`
  - `C-c o >`: `org-clock-in`
  - `C-c o <`: `org-clock-out`
  - `C-c C-s`: `org-schedule`
  - `C-c C-d`: `org-deadline`
