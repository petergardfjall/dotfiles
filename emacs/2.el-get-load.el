;;
;; Installs el-get: an "apt-get like" package manager for Emacs.
;;
;;    https://github.com/dimitri/el-get
;;    https://github.com/dimitri/el-get/blob/master/el-get.info
;;
;; El-get is similar to package.el (Emacs24 built-in) except that it 
;; automatically installs all the dependencies and can install
;; extensions that require non-lisp code/commands to be executed.
;;

;; Where el-get stores itself and installed packages
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;; Make sure el-get installs itself if it hasn't already been installed.
;; This download may take a while but is only performed once.
(setq el-get-verbose t)
;; Uses the master branch of el-get (with newer recipes than stable branch)
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

;; el-get-recipe-path: directory path containing el-get 'recipes'
;; (.rcp package descriptions). The default one is a local (downloaded) 
;; version of: https://github.com/dimitri/el-get/tree/master/recipes
;;
;; Add a local directory to the recipe path:
(add-to-list 'el-get-recipe-path "~/dotfiles/emacs/el-get/recipes")
;; Overwrite the recipe path with an entirely local one:
;;(setq el-get-recipe-path '("~/dotfiles/emacs/el-get/recipes"))

;; Directory holding init-<package>.el files for installed packages
;; that are to be loaded to initialize a given package.
(setq el-get-user-package-directory "~/dotfiles/emacs/el-get/initfiles")

;; On emacs 23, ~/.emacs.d/elpa directory needs to be created
(make-directory (expand-file-name "~/.emacs.d/elpa") t)


;; The packages to be installed by el-get.
;; Their init files (if needed) are in the 'el-get-user-package-directory'
(setq installed_packages 
      '(cl-lib auto-complete pymacs ropemacs jedi)
)
;; Go through packages and install the ones missing (including dependencies)
;; and look for init-<package>.el initialization code to set up each package.
(el-get 'sync installed_packages)
