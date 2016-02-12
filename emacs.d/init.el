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
  '(markdown-mode python jbeans-theme)
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
;; Set up hooks for configuration that is to take place after packages have
;; been loaded (loading happens on exit of init.el).
;;

(eval-after-load "jbeans-theme"
  (load-theme 'jbeans t))
