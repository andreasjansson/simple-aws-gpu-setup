(blink-cursor-mode 0)
(setq backup-inhibited t)
(setq auto-save-default nil)
(recentf-mode t)
(setq disabled-command-function nil)
(setq-default indent-tabs-mode nil)
(add-to-list 'load-path "~/.emacs.d")
(define-coding-system-alias 'UTF-8 'utf-8)
(global-set-key [(control x) (k)] 'kill-this-buffer)

(require 'package)
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
                          ("gnu" . "http://elpa.gnu.org/packages/")
                          ("marmalade" . "http://marmalade-repo.org/packages/")
                          ("melpa" . "http://melpa.milkbox.net/packages/")))
(setq package-list '
      (
       ace-jump-mode
       color-theme
       browse-kill-ring
       ))
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; colours
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))

;; ido
;(ido-mode)
(iswitchb-mode t)

;; ace-jump
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; python
(defun insert-ipdb-set-trace ()
  "Insert 'import ipdb; ipdb.set_trace()' here."
  (interactive)
  (insert "import ipdb; ipdb.set_trace()"))

(add-hook 'python-mode-hook
          '(lambda ()
             (subword-mode t)
             (flymake-mode t)
             (local-set-key (kbd "C-c p") 'insert-ipdb-set-trace)
             (local-set-key (kbd "C-c f n") 'flymake-goto-next-error)
             (local-set-key (kbd "C-c f p") 'flymake-goto-prev-error)
             (local-set-key (kbd "C-c f SPC") 'flymake-display-err-menu-for-current-line)
          ))
(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter-args "--pylab"
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
 "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
 "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
 "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;; Configure flymake for Python
(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "epylint" (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init)))

;; server
(server-mode t)

(require 'uniquify)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(create-lockfiles nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
