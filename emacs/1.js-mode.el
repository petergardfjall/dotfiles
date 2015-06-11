; make sure .json files also activate the js-mode
(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))

; hook to use 4 space indentation
(defun my-js-mode-hook ()
  (setq indent-tabs-mode nil js-indent-level 4))
(add-hook 'js-mode-hook 'my-js-mode-hook)
