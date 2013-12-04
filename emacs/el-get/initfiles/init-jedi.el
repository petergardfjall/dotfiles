;; Jedi.el is a Python auto-completion package for Emacs.

;; Fully set up jedi.el for the current buffer:
;; it sets up ac-sources (calls jedi:ac-setup) and turns jedi-mode on.
(add-hook 'python-mode-hook 'jedi:setup)
;; If auto-completion is all you need, use jedi:ac-setup instead:
;; (add-hook 'python-mode-hook 'jedi:ac-setup)

;; Set up recommended keybinds for Jedi.el (optional)
(setq jedi:setup-keys t)
;; Avoid collision with ropemacs's show doc (uses 'C-c d')
(setq jedi:key-show-doc (kbd "C-c D"))

;; Automatically start completion when entering a '.' (optional)
(setq jedi:complete-on-dot t)
