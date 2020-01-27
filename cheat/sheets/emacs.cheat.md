## Legend
- `M` = Meta (or Alt)
- `C` = Ctrl

## General

- Exit:                           `C-x C-c`

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


- Open a shell:             `M-x shell`
- Open a terminal:          `M-x ansi-term`
  - Switch to `char mode`:  `C-c C-k`
  - Switch to `line mode`:  `C-c C-j`

## Shell commands
- Execute a shell command:       `M-!`
- Open shell in `*shell*` buffer:  `M-x shell`


## Web browser
- Open web page:       `M-x eww <URL>`
- Reload web page:     `M-x eww-reload`


## Lisp
Go to the *scratch* buffer, enter an expression, like `(+ 1 1)`, and run `C-j`
to have the last expression evaluated.


## Concepts:

- https://www.gnu.org/software/emacs/manual/html_node/emacs/Screen.html#Screen: frame > window > buffer

- commands (interactive functions)

- modes: https://www.gnu.org/software/emacs/manual/html_node/emacs/Modes.html#Modes

- hooks
  TODO: https://www.gnu.org/software/emacs/manual/html_node/emacs/Hooks.html

  https://www.gnu.org/software/emacs/manual/html_node/elisp/Standard-Hooks.html
- `after-init-hook`
- `emacs-startup-hook`
- `<modename>-mode-hook`
- `after-save-hook`, `before-save-hook`

- autoloads

TODO: https://www.emacswiki.org/emacs/AutoLoad

TODO: `auto-mode-alist`: https://www.emacswiki.org/emacs/AutoModeAlist
TODO: `interpreter-mode-alist`: https://www.emacswiki.org/emacs/InterpreterModeAlist


## Theme
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

## Custom keybindings
Navigation:
- `Shift-<arrow>`: `windmove-{up|down|left|right}` (move between windows)
- `C-S-<up|down>`: `enlarge-window|shrink-window` (on v-split windows)
- `C-S-<left|right>`: `{enlarge-window|shrink-window}-horizontally` (on h-split windows)

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
