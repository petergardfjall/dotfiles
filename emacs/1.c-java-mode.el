; If a line is not properly indented move the cursor to that line,
; issue C-c C-o to adjust that indentation rule. That will also show
; the name of that offset rule.

(setq line-number-mode t)              ; turn on line numbers
(setq column-number-mode t)            ; turn on column numbers
(setq visible-bell t)                  ; flash instead of bell on errors

; automatic syntax highlighting
(if (fboundp 'global-font-lock-mode)   
    (global-font-lock-mode 1)          ; for GNU Emacs
  (setq font-lock-auto-fontify t))     ; for XEmacs

; Create C/C++ environment with indent-level 4
(defun my-c-indent-setup ()
  (define-key c-mode-map "\C-m" 
    'reindent-then-newline-and-indent) ; on RET, start next line indented
  (setq c-basic-offset 4)              ; set default C/C++ indentation to 4 spaces
  (setq indent-tabs-mode nil)          ; replace tabs with spaces
  (c-set-offset 'case-label 4)         ; case labels have one level indent
  (c-set-offset 'arglist-intro 4)      ; argument list (on own line) has one level indent
  (c-set-offset 'arglist-close 0)      ; closing function call brace has no extra indent
)

; Create Java environment with indent-level 4
(defun my-java-indent-setup ()
  (define-key java-mode-map "\C-m" 
    'reindent-then-newline-and-indent) ; on RET, start next line indented
  (setq indent-tabs-mode nil)          ; replace tabs with spaces
  (c-set-offset 'case-label 4)         ; case labels have one level indent
  (c-set-offset 'arglist-intro 4)      ; argument list (on own line) has one level indent
  (c-set-offset 'arglist-close 0)      ; closing function call brace has no extra indent
)

(add-hook 'java-mode-hook 'my-java-indent-setup)
(add-hook 'c-mode-hook 'my-c-indent-setup)
(add-hook 'c++-mode-hook 'my-c-indent-setup)