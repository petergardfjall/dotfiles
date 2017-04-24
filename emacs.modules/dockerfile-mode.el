;;
;; Syntax highlightning for Dockerfile buffers
;;
(add-to-list 'load-path "~/dotfiles/emacs.modules/dockerfile-mode/")
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
