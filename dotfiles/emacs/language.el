; 8-bits swedish characters
(set-language-environment "UTF-8")
(set-input-mode (car (current-input-mode))
       (nth 1 (current-input-mode))
       0)
