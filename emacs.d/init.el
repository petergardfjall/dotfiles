;; Main entry-point for emacs configuration.
;; See http://wikemacs.org/wiki/Package.el


;; Use the package.el package manager that comes bundled with Emacs24
(require 'package)
(package-initialize)

(message "Loading init.el ...")

;; add package archives
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("org" . "http://orgmode.org/elpa/") t)


;; Common Lisp for Emacs
(require 'cl-lib)
 
(defvar my-packages
  '(markdown-mode
    yaml-mode
    python         ;; Python mode
    go-mode        ;; Golang mode
    go-autocomplete
    jbeans-theme   ;; Color theme
    auto-complete  ;; Generic auto-completion functionality
    powerline      ;; Prettier mode line at bottom of screen
    neotree        ;; File navigator on the left via F8
    flycheck       ;; on-the-fly syntax checking
    jedi           ;; Python auto-completion
    )
  "A list of packages to ensure are installed at launch.")
 
(defun my-packages-installed-p ()
  (cl-loop for p in my-packages
	   when (not (package-installed-p p))  do (cl-return nil)
	   finally (cl-return t)))
 
(unless (my-packages-installed-p)
  ;; check for new packages (package versions)
  (message "%s" "Emacs Prelude is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; install the missing packages
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))


;;
;; General settings
;;
(set-language-environment "UTF-8")
(setq inhibit-startup-screen t)
(setq column-number-mode t)
; set the default font to use
(add-to-list 'default-frame-alist
             '(font . "DejaVu Sans Mono-10"))
(set-face-attribute 'default nil :font  "DejaVu Sans Mono-10")
;; Allow copy/paste to/from system clipboard
(setq x-select-enable-clipboard t) 
;; Middle mouse button inserts the clipboard (rather than emacs primary)
(global-set-key (kbd "<mouse-2>") 'x-clipboard-yank)



;;
;; Package configurations that can be set before the packages have been loaded
;; (happens on exit of init.el)
;;

;; js-mode: use 4 space indentation
(add-hook 'js-mode-hook
 	  '(lambda()(setq indent-tabs-mode nil js-indent-level 4)))

;; RETURN should start indented on the next line.
(add-hook 'yaml-mode-hook
	  (lambda ()
	    (define-key yaml-mode-map "\C-m" 'newline-and-indent)))



;;
;; Set up hooks for configuration that is to take place after packages have
;; been loaded (loading happens on exit of init.el).
;;

(add-hook 'after-init-hook 'package-setup-hook)
(defun package-setup-hook ()
  ;; do things after package initialization
  (message "running package-setup-hook ...")

  (require 'jbeans-theme)
  (load-theme 'jbeans t)

  (require 'powerline)
  (powerline-default-theme)
  ;;(powerline-vim-theme)

  (require 'go-autocomplete)
  (require 'auto-complete)
  (ac-config-default)

  ;; Bind RETURN to "newline followed by indent"
  (require 'python)
  (add-hook 'python-mode-hook
	    '(lambda () (define-key python-mode-map
			  "\C-m" 'newline-and-indent)))

  (require 'neotree)
  (global-set-key [f8] 'neotree-toggle)

  ;; On-the-fly syntax checking (support for different languages)
  (require 'flycheck)
  (global-flycheck-mode)

  ;; Python auto-completion
  (add-hook 'python-mode-hook 'jedi:setup)
  ;; Set up recommended key bindings (optional)
  (setq jedi:setup-keys t)
  ;; Automatically start completion when entering a '.' (optional)
  (setq jedi:complete-on-dot t)  
  ;; Avoid collision with ropemacs's show doc (uses 'C-c d')
  ;; (setq jedi:key-show-doc (kbd "C-c D"))

  ;;
  ;; http://yousefourabi.com/blog/2014/05/emacs-for-go/
  (require 'go-mode)
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-hook 'go-mode-hook
	    '(lambda ()
	       (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
	       (local-set-key (kbd "C-c C-g") 'go-goto-imports)
	       (local-set-key (kbd "C-c C-f") 'gofmt)
	       ))
  (add-hook 'go-mode-hook 'auto-complete-mode)
  )


(message "%s" "init.el done.")