;; Main entry-point for emacs configuration.
;; See http://wikemacs.org/wiki/Package.el

;; Use the package.el package manager that comes bundled with Emacs24
(require 'package)
(package-initialize)

;; add package archives
(add-to-list 'package-archives
	     '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("org" . "http://orgmode.org/elpa/") t)


;; Common Lisp for Emacs. TODO: should be cl-lib?
(require 'cl)
 
(defvar my-packages
  '(ack-and-a-half markdown-mode python solarized-theme)
  "A list of packages to ensure are installed at launch.")
 
(defun my-packages-installed-p ()
  (loop for p in my-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))
 
(unless (my-packages-installed-p)
  ;; check for new packages (package versions)
  (package-refresh-contents)
  ;; install the missing packages
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))


;;
;; Set up hooks for configuration that is to take place after packages have
;; been loaded (loading happens on exit of init.el).
;;

;; Set up solarized theme
;; NOTE: for the theme to work in terminal mode you may need to set
;;   export TERM=xterm-256color
(eval-after-load "solarized-theme"
  (if (require 'solarized nil t)
      (progn
	(setq solarized-termcolors '256)
	(load-theme 'solarized-dark t)
	)
    (warn "solarized-theme package not found.")))
