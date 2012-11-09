(load-file "~/.emacs.d/c-java-mode.el")
(load-file "~/.emacs.d/ruby-mode.el")
(setq auto-mode-alist (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(load-file "~/.emacs.d/python-mode.el")

; 8-bits swedish characters
(set-language-environment "UTF-8")
(set-input-mode (car (current-input-mode))
       (nth 1 (current-input-mode))
       0)

; Add Ruby-mode setup
;(add-to-list 'load-path (expand-file-name "~/.emacs.d"))
;(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))      
;(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
;(setq auto-mode-alist (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
;(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))

; Set up default coloring scheme
(set-background-color "Black")
(set-foreground-color "White")
(set-cursor-color "White")
; Set up coloring scheme for syntax highlightning
; Uncomment any line to override defaults
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(global-font-lock-mode t nil (font-lock))
 '(inhibit-startup-screen t)
 '(nil nil t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
