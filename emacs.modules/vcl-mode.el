;;
;; Syntax highlightning for Varnish Configuration Languave (VCL) buffers
;;
(add-to-list 'load-path "~/dotfiles/emacs.modules/emacs-vcl-mode/")
(require 'vcl-mode)
(add-to-list 'auto-mode-alist '("\\.vcl\\'" . vcl-mode))
(setq vcl-indent-level 4)
