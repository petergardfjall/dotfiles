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


;; Common Lisp for Emacs. TODO: should be cl-lib?
(require 'cl)
 
(defvar my-packages
  '(markdown-mode
    python
    jbeans-theme
    auto-complete
    powerline
    )
  "A list of packages to ensure are installed at launch.")
 
(defun my-packages-installed-p ()
  (loop for p in my-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))
 
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

  (require 'auto-complete)
  (ac-config-default)

  (require 'python)
  (add-hook 'python-mode-hook
	    '(lambda () (define-key python-mode-map
			  "\C-m" 'newline-and-indent)))

  )

(message "%s" "init.el done.")
