;
; Language settings
; 
(set-language-environment "UTF-8")
(set-input-mode (car (current-input-mode))
       (nth 1 (current-input-mode))
       0)

;
; Set up default coloring scheme
;
(set-background-color "Black")
(set-foreground-color "White")
(set-cursor-color "White")
; Set up coloring scheme for syntax highlightning
(custom-set-variables
 '(global-font-lock-mode t nil (font-lock))
 '(inhibit-startup-screen t)
 '(nil nil t))

;
; set the default font to use
;
(add-to-list 'default-frame-alist
             '(font . "DejaVu Sans Mono-10"))
(set-face-attribute 'default nil :font  "DejaVu Sans Mono-10")

;
; Set up some global keyboard mappings
;
; Make sure backtick can be written
(global-set-key [S-dead-grave] "`")
(global-set-key [dead-tilde] "~")