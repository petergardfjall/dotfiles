;
; Settings for python mode (based on python.el).
;
; For more details on its use, refer to:
;   http://www.emacswiki.org/emacs/ProgrammingWithPythonDotEl
;

(message "Emacs version: %s" emacs-version)
;; emacs versions 24.1+ all come with python.el python mode by default.
;; if we are running in an emacs version earlier than 24.1, we load the 
;; "gallina python.el" python mode (see https://github.com/fgallina/python.el).
(if (string< emacs-version "24.1") 
    (progn
      (message "Emacs version prior to 24.1. Loading gallina python.el ...")
      (add-to-list 'load-path "~/dotfiles/emacs/python/"))
    nil)

(require 'python)
; bind RETURN to "newline followed by indent", rather than "newline only".
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-m" 'newline-and-indent)))
