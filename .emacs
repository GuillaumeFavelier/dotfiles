;;; disable backup
(setq backup-inhibited t)

;;; disable auto save
(setq auto-save-default nil)

;;; black background
(add-to-list 'default-frame-alist '(background-color . "#000000"))

;;; emacs strip tease
(blink-cursor-mode 0)
(setq initial-scratch-message "")
(setq inhibit-startup-message t)
(setq visible-bell t)
(scroll-bar-mode 0)
(toggle-frame-fullscreen)
(tool-bar-mode 0)
(menu-bar-mode 0)

;;; octave-mod
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))

;;; linum-mode
(setq linum-format "%d ")
(add-hook 'find-file-hook (lambda () (linum-mode 1)))

;;; alias
(defalias 'qrr 'query-replace-regexp)
(custom-set-variables)
(custom-set-faces
 '(linum ((t (:inherit (shadow default) :foreground "yellow")))))
