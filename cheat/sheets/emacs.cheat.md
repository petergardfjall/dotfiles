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
- Toggle line numbers:            `M-x linum-mode`

- Customize/select theme:         `M-x customize-themes`
- Customize variables and faces:  `M-x customize`

- Reload configuration:           `M-x load-file ~/.emacs`

## Appearance
- Increase buffer font size:      `C-x C-+`
- Decrease buffer font size:      `C-x C--`

## Packages
- Refresh and list packages: `M-x list-packages`

- In package view, press `U` to mark all upgradable packages for upgrade, and `x`
- to perform the upgrades.


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

## Shell commands
- Execute a shell command:       `M-!`
- Open shell in `*shell*` buffer:  `M-x shell`

## Programming
*General*:
- comment-line:                 `C-c c`
- commen-region:                `<mark> + C-c c`
- list-flycheck-errors:         `C-c e`

*LSP-mode*:
- lsp-find-definition           `<M-down>`
- xref-pop-marker-stack         `<M-up>`
- lsp-ui-peek-find-definitions  `C-c p d`
- lsp-ui-peek-find-references   `C-c p r`
- lsp-hover                     `C-c h`
- lsp-find-definition           `C-c f d`
- lsp-find-references           `C-c f r`
- lsp-rename                    `C-c C-r`
- lsp-describe-thing-at-point   `C-c C-d`
- restart lsp server:           `M-x lsp-restart-workspace`

*Snippets*
- Expand snippet:                 `<type trigger><TAB>`
- Show available snippets:        `M-x yas-describe-tables`

## Web browser
- Open web page:       `M-x eww <URL>`
- Reload web page:     `M-x eww-reload`

## Lisp
Go to the *scratch* buffer, enter an expression, like `(+ 1 1)`, and run `C-j`
to have the last expression evaluated.