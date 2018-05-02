;;; disable backup
(setq backup-inhibited t)

;;; disable auto save
(setq auto-save-default nil)

;;; linum-mode
(setq linum-format "%d ")
(add-hook 'find-file-hook (lambda () (linum-mode 1)))
