## Legend
- `M` = Meta (or Alt)
- `C` = Ctrl

## General

- Exit:                           `C-x C-c`

## Help
- Help:                           `C-h` (or `F1`)
- *A*propos: show matching commands `C-h a <match-string>`
- Describe function for *k*ey       `C-h k <keyboard-shortcut>`
- Describe a *f*unction             `C-h f`
- Get key *b*indings in buffer      `C-h b` or `M-x describe-mode`
- Get *m*ode-specific information   `C-h m`
- Display value and doc of *v*ar    `C-h v var <RET>`

- List keyboard shortcuts:        `M-x describe-bindings`
- List all personal keybindings:  `M-x describe-personal-keybindings`
- Toggle line numbers:            `M-x linum-mode`

- Customize/select theme:         `M-x customize-themes`
- Customize variables and faces:  `M-x customize`
- Set a customizable var:         `M-x customize-set-variable <var>`

- Reload configuration:           `M-x load-file ~/.emacs`

## Appearance
- Increase buffer font size:      `C-x C-+`
- Decrease buffer font size:      `C-x C--`

## Packages
- Refresh and list packages:      `M-x list-packages`

- In package view, press `U` to mark all upgradable packages for upgrade, and
  `x` to perform the upgrades.


## Major Mode:
- Describe current major-mode:  `M-x describe-mode`
- Set mode (e.g. `yaml-mode`):    `M-x <mode>`

## File and buffers
- Open file:             `C-x C-f`
- Save buffer:           `C-x C-s`
- Save all:              `C-x s`
- Kill/close frame:      `M-x delete-frame`
- List buffers:          `C-x C-b`
  - `d` to mark for *deletion*
  - `u` to *unmark*
  - `x` to *execute* marked deletions
- Switch buffer:         `C-x b <buffer>`
- Kill/close buffer:     `C-x k`
- Restore buffer:        `M-x revert-buffer`

## Multiple windows (in buffer)
- Split window:           `C-x 2` (vertical) `C-x 3` (horizontal)
- Switch to other window: `C-x o`
- Close other windows:    `C-x 1`
- Close this window:      `C-x 0`

## Navigation
- One word forward:       `M-f`
- One word backward:      `M-b`
- One expression forward: `C-M-f` (jump to closing delimiter/parenthesis)
- One expression back:    `C-M-b` (jump to opening delimiter/parenthesis)
- Start of buffer:        `M-<`
- End of buffer:          `M->`
- Start of line:          `C-a`
- End of line:            `C-e`
- Goto line:              `M-g g`
- Save point to register:     `C-x r <SPC> <name>`
- Jump to point in register:  `C-x r j <name>`

## Editing
- Undo:                            `C-x u`
- Cancel/abort command:            `C-g`
- Delete (rest of) row:            `C-k`
- Delete (next) word:              `M-d`
- Delete (previous) word:          `M-Backspace`
- Delete selection/region:         `C-w` or `M-x delete-region`
- Delete trailing whitespace:      `M-x delete-trailing-whitespace`
- Insert `<str>` on each line        `C-sp, move to row, C-x r t <str>`
- Break paragraph lines (@fillcol) `M-q`
- set-fill-column                  `C-x f <col>`
- Uppercase word at cursor         `M-u`
- Lowercase word at cursor         `M-l`
- Capitalize word at cursor        `M-c`

*Rectangle*:
- Start rectangle corner at cursor:     `C-space`
- Prefix each rectangle line with text: `C-x r t <chars>`
- Kill rectangle:                       `C-x r k`
- Copy rectangle                        `C-x r M-w`
- Yank rectangle:                       `C-x r y`

## Copy-paste
- Start selection:        `C-Space`
- Select all:             `C-x h`
- Copy (region):          `M-w`
- Cut (region):           `C-w`
- Insert another file:    `C-x i`
- Paste (yank):           `C-y`

## Indentation
- Indent rigidly (marked rows):  `C-u C-x TAB`
- Decrease indent by 2:          `C-u 2 C-x TAB`
- Decrease indent by 4:          `C-u -4 C-x TAB`
- Mode-aware indent:             `M-x indent-region`

## Search/replace
- Search forward:         `C-s`
- Search backward:        `C-r`
- Query replace:          `M-%`
- Replace with regexp:    `M-x query-replace-regexp`

## Bookmarks
- Set bookmark at point:  `C-x r m`
- Jump to bookmark:       `C-x r b`
- List bookmarks:         `C-x r l`
- Delete bookmark:        `M-x bookmark-delete`

## Shell/terminal
There are a couple of ways to open a subshell and run external (to emacs)
commands: `shell` and (`ansi-`)`term`.

In a `shell`, emacs is used to edit a command-line (the subprocess doesn't see
any input until you present return). It's easy to move around the buffer, mark
output, copy, etc just like a normal buffer.

In a `terminal`, each keypress is captured by the subprocess. Or, to be precise,
there are two modes: `char mode` (each character is captured by the shell,
meaning that normal emacs keybindings `C-x *` aren't be available) and `line
mode` (which works like a normal emacs buffer).

- Open a shell:                           `M-x shell`
- Open a terminal:                        `M-x ansi-term`
  - Switch to `char mode` (`term-char-mode`): `C-c C-k`
  - Switch to `line mode` (`term-line-mode`): `C-c C-j`

## Shell commands
- Execute a shell command:       `M-!`
- Open shell in `*shell*` buffer:  `M-x shell`


## Web browser
- Open web page:       `M-x eww <URL>`
- Reload web page:     `M-x eww-reload`


## Lisp
Go to the *scratch* buffer, enter an expression, like `(+ 1 1)`, and run `C-j`
to have the last expression evaluated.


## Concepts
Emacs' graphical layout has three primary concepts:

- *Frame*: a graphical window or terminal screen occupied by Emacs.
- *Window*: Occupies the main area of the frame and displays a single buffer. A
  frame can be split to display multiple windows.
- *Buffer*: the contents displayed in a frame. A buffer is commonly visiting a
  file.

- commands (interactive functions)

- modes: https://www.gnu.org/software/emacs/manual/html_node/emacs/Modes.html#Modes

- hooks
  TODO: https://www.gnu.org/software/emacs/manual/html_node/emacs/Hooks.html


- autoloads

TODO: https://www.emacswiki.org/emacs/AutoLoad

TODO: `auto-mode-alist`: https://www.emacswiki.org/emacs/AutoModeAlist
TODO: `interpreter-mode-alist`: https://www.emacswiki.org/emacs/InterpreterModeAlist


## Themes
- `M-x load-theme <theme>`: load and apply a particular theme.
- `M-x customize-create-theme`: opens the theme customization tool that shows
  all basic faces that need to be filled out by a theme.
- `M-x customize-face <face>`: allows a particular editor face to be edited
  (default: `all faces` shows every face)
- `M-x list-faces-display`: list and customize faces.
- `M-x describe-face`: describe the face at point.
- `M-x describe-text-properties`: learn all faces being used at point: faces for
  overlays at point, face which in turn is a list of faces (as in org mode tags)


## Tramp-mode
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


## Debugging
To make every `error` call dump a backtrace:
- `(setq debug-on-error t)`
- `M-x toggle-debug-on-error`)
- `emacs --eval '(setq debug-on-error t)' <file>`


## Org mode
Org mode is a plain text system for keeping notes, maintaining to-do lists,
planning, scheduling and even authoring. In short, a mode for organizing life.

It's implemented on top of *outline mode*, a mode specialized at managing
(editing, navigating, visibility-cycling) tree-structured content.

*Headings* are marked with leading asterisks `*`, with a deeper (sub)heading in
the tree indicated by one more leading asterisk. Text under each heading is
called the *body*, and together a heading and a body forms an *entry*.

Outline-mode:
- `TAB`/`org-cycle`: local visibility cycling over states `FOLDED`, `CHILDREN`,
  `SUBTREE`
- `S-TAB`/`org-global-cycle`: global visibility cycling over states `OVERVIEW`,
  `CONTENTS`, `SHOW ALL`
- `M-RET`/`org-meta-return`: insert new heading at current heading level
  - `TAB`/`org-cycle`: cycle level in a new entry (each press demotes one level)
- `M-S-RET`/`org-insert-todo-heading`:  insert `TODO` heading at current level
- `M-left`/`org-do-promote`: promote current entry one level
- `M-right`/`org-do-demote`: demote current entry one level
- `M-S-left`/`org-promote-subtree`: promote current subtree one level
- `M-S-right`/`org-demote-subtree`: demote current subtree one level
- `M-up`/`org-move-subtree-up`: move subtree up before prior entry
- `M-down`/`org-move-subtree-down`: move subtree down after next entry
Within an outline tree, one can also add lists to entry bodies.
- *Unordered lists* start with `-`, `+` or `*`
- *Ordered lists* start with `1.` or `1)`
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
Scheduling and deadlines:
-

## Custom keybindings
Navigation:
- `C-x w <arrow>`: `windmove-{up|down|left|right}` (move between windows)
Window management hydra:
- Prefix: `C-c C-w`
  - `<arrow>`:        `windmove-{up|down|left|right}`
  - `S-<up|down>`:    `enlarge-window|shrink-window` (on v-split win)
  - `S-<left|right>`: `{enlarge|shrink}-window-horizontally` (on h-splits win)

Text size:
- `C-x C-+`: `default-text-scale-increase`
- `C-x C--`: `default-text-scale-decrease`
- `C-x C-0`: `default-text-scale-reset`

Enter "IDE mode":
- `F6`:  enable `desktop-save-mode`
- `F7`: `projectile-mode`
- `F8`: `toggle-treemacs`

Formatting:
- `C-c c`: `comment-line`
- `C-c w`: `delete-trailing-whitespace`

General find definition of thing at point (if supported by mode):
- `M-<down>`:   `xref-find-definitions`
- `M-<up>`:     `xref-pop-marker-stack`
- `C-c f d`:    `xref-find-definitions`
- `C-c f r`:    `xref-find-references`
- `C-c C-d`:    `describe-symbol` (any docs for thing at point?)

Find file (in project)
- `C-c f f`   `projectile-find-file`

Undo:
- `C-x u`:  `undo`
- `C-z`:    `undo-tree-undo`
- `C-Z`:    `undo-tree-redo`
- `C-c u t` `undo-tree-visualize` (show undo tree: select state and press 'q')

Auto-completion:
- `C-<tab>` `company-complete`

Show errors in current buffer:
- `C-c s e`:  `list-flycheck-errors`

"Find type" ("find tag"), requires `gtags` to have been run on project.
- `C-c f t`: `ggtags-find-definition`

Free-text search (via ag/silversurfer):
- `C-c s p`: `counsel-projectile-ag` ("search-in-project")

Language Server Protocol interactions:
- `<M-down>`   `lsp-find-definition`
- `<M-up>`     `xref-pop-marker-stack`
- `C-c p d`    `lsp-ui-peek-find-definitions`
- `C-c p r`    `lsp-ui-peek-find-references`
- `C-c h`      `lsp-document-highlight`
- `C-c f d`    `lsp-find-definition`
- `C-c f i`    `lsp-goto-implementation`
- `C-c f r`    `lsp-find-references`
- `C-c C-r`    `lsp-rename`
- `C-c C-d`    `lsp-describe-thing-at-point`
- `C-c d`      `lsp-ui-doc-show`
- `C-c e`      `lsp-ui-doc-hide` ("end doc show")

Snippets:
- `<type trigger><TAB>`: expand snippet
- `M-x yas-describe-tables`: show available snippets

Markdown-mode:
- `C-c p m`    `markdown-preview-mode`

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
