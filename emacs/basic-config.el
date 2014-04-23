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
(set-frame-font "DejaVu Sans Mono-10" nil t)
