(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; packages to install:
;; evil
;; evil-leader
;; evil-surround
;; evil-nerd-commenter
;; evil-matchit
;; dtrt-indent
;; helm
;; projectile
;; helm-projectile
;; typescript-mode

(dtrt-indent-mode t)
(define-key global-map (kbd "RET") 'newline-and-indent)

(require 'evil)
(evil-mode t)

(define-key evil-insert-state-map (kbd "<RET>") 'newline-and-indent)

(global-evil-leader-mode)
(evil-leader/set-leader "\\")
(setq evil-leader/in-all-states 1)
(evil-leader/set-key
  "f" 'helm-find-files
  "b" 'switch-to-buffer)
(global-set-key (kbd "C-x k") 'kill-this-buffer)

(require 'evil-surround)
(global-evil-surround-mode t)

(require 'evil-matchit)
(global-evil-matchit-mode t)

;; esc quits
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

;; Remove useless GUI widgets
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)
;; Prevent clipboard transfers at exit (hangs...)
(setq x-select-enable-clipboard-manager nil)

;; Disable syntax highlight
(global-font-lock-mode 0)
;; Disable syntax highlight in typescript-mode
;; Somehow still enabled even after global-font-lock-mode setting.
(add-hook 'typescript-mode-hook (lambda () (font-lock-mode 0)))
(set-default-font "DejaVu Sans Mono 12")
(load-theme 'wombat)

;; Indent/tabs
(setq-default indent-tabs-mode nil
              tab-width 4)

(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)

;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(package-selected-packages
   (quote
    (typescript-mode helm-projectile 0blayout projectile evil-matchit evil-nerd-commenter evil-surround dtrt-indent evil-leader evil))))

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(helm-mode t)

(projectile-global-mode)
(setq projectile-completion-system 'helm)
(require 'helm-projectile)
(helm-projectile-on)

(defun shell-hook ()
  (evil-local-mode 0)
  (font-lock-mode 1))

(add-hook 'eshell-mode-hook 'shell-hook)
(add-hook 'term-mode-hook 'shell-hook)
