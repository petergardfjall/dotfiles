;
; Uses the emacs23 branch of the "gallina python.el" python mode code which 
; is now *included* in Emacs 24 (see https://github.com/fgallina/python.el).
; For more details on its use, refer to:
;   http://www.emacswiki.org/emacs/ProgrammingWithPythonDotEl
;
(add-to-list 'load-path "~/dotfiles/emacs/python/")
(require 'python)
; bind RETURN to "newline followed by indent", rather than "newline only".
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-m" 'newline-and-indent)))