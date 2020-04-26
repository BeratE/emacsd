(setq user-full-name "Berat Ertural"
      user-mail-address "berat.ertural@rwth-aachen.de")

(load-theme 'tango-dark t)

(add-to-list 'default-frame-alist
             (cond
              ((string-equal system-type "darwin")    '(font . "Fira Code-13"))
              ((string-equal system-type "gnu/linux") '(font . "Fira Code-11"))))

;; Theres a bug in Emacs (Bad Reques)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Optimization
(setq gc-cons-threshold 100000000 ;  100mb
      read-process-output-max (* 1024 1024)) ; 1 mb

(defalias 'yes-or-no-p 'y-or-n-p)

;; Keep all backup and auto-save files in one directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; UTF-8 encoding
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)


(setq-default inhibit-startup-screen t
              indent-tabs-mode nil
              indicate-empty-lines t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(show-paren-mode t)
(global-linum-mode t)
(column-number-mode t)
(delete-selection-mode t)

(setq shell-command-switch "-ic")

(use-package org)

  ;; Org-mode #+setupfile: tings
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-c l" 'org-store-link)
(global-set-key "\C-c a" 'org-agenda)
(setq org-log-done t)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(use-package ob-restclient
  :ensure t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (C . t)
   (calc . t)
   (latex . t)
   (java . t)
   (ruby . t)
   (lisp . t)
   (scheme . t)
   (shell . t)
   (sqlite . t)
   (js . t)
   (restclient . t)
   (ledger . t)))

(defun my-org-confirm-babel-evaluate (lang body)
  "Do not confirm evaluation for these languages."
  (not (or (string= lang "C")
           (string= lang "java")
           (string= lang "python")
           (string= lang "emacs-lisp")
           (string= lang "sqlite"))))
(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

(setq ob-async-no-async-languages-alist '("ipython"))

(setq org-src-fontify-natively t
      org-src-window-setup 'current-window
      org-src-strip-leading-and-trailing-blank-lines t
      org-src-preserve-indentation t
      org-src-tab-acts-natively t)

(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("md" . "src markdown"))
(add-to-list 'org-structure-template-alist '("gq" . "src graphql"))

(use-package ox-pandoc
  :no-require t
  :defer 10
  :ensure t)

(use-package which-key
  :config
  (which-key-mode))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :commands (projectile-mode projectile-switch-project)
  :bind (("C-c p p" . projectile-switch-project)
         ("C-c p s s" . projectile-ag)
         ("C-c p s r" . projectile-ripgrep))
  :config
  (setq projectile-keymap-prefix (kbd "C-c p"))
  (projectile-global-mode t)
  (setq projectile-enable-caching t))

(use-package helm
  :disabled t
  :ensure t
  :diminish helm-mode
  :bind (("C-c h" . helm-command-prefix)
	 ("C-x b" . helm-mini)
	 ("C-`" . helm-resume)
	 ("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files)
	 ("C-x C-r" . helm-recentf))
  :init
  (require 'helm-config)
  :config
  (setq helm-locate-command "mdfind -interpret -name %s %s"
	helm-ff-newfile-prompt-p nil
	helm-M-x-fuzzy-match t)
  (helm-mode)
  (set-face-attribute 'helm-source-header nil :height 0.1)
  (helm-autoresize-mode 1)
  (setq helm-display-header-line nil)
  (setq helm-autoresize-max-height 30)
  (setq helm-autoresize-min-height 30))

(use-package helm-projectile
  :ensure t
  :after helm-mode
  :commands helm-projectile
  :bind ("C-c p h" . helm-projectile))

(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :defer 10
  :config 
  (setq flycheck-html-tidy-executable "tidy5")
  (global-flycheck-mode))

(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
  (add-to-list 'yas-snippet-dirs (locate-user-emacs-file "snippets"))
  (setq yas-indent-line 'fixed)
  (yas-global-mode))

(use-package company
  :ensure t
  :diminish company-mode
  :config
  (setq company-tooltip-limit 20)
  (setq company-idle-delay .15)
  (setq company-echo-delay 0)
  (setq company-begin-commands '(self-insert-command))
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (add-hook 'after-init-hook 'global-company-mode))

(use-package undo-tree
  :diminish undo-tree-mode
  :bind (("M-/" . undo-tree-visualize)))

(use-package sr-speedbar
  :ensure t
  :config
  (setq speedbar-show-unknown-files t))

(require 'smartparens-config)
(setq smartparens-global-mode t)

(use-package ccls
  :init
  (setq ccls-executable "/home/berat/aur/ccls/Release/ccls")
  :config
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc)))

(use-package lsp-mode
  :ensure ccls
  :hook prog-mode
  :bind (("C-c l" . lsp-keymap-prefix))
  :config
  (setq lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error"))
  (setq lsp-enable-indentation nil)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

;; Company-LSP
(require 'company-lsp)
(push 'company-lsp company-backends)

(use-package tex
  :ensure auctex
  :config
  (setq-default TeX-master nil))

(setq gdb-many-windows t)

(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html\\.twig\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))

(use-package slime
  :hook lisp-mode
  :init
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (load "~/quicklisp/clhs-use-local.el" t)
  (load (expand-file-name "~/quicklisp/slime-helper.el")))

(require 'rgbds-mode)
(add-to-list 'auto-mode-alist '("\\.inc\\'" . asm-mode))

(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
(setq lua-indent-level 2)

(autoload 'glsl-mode "glsl-mode" "GLSL Editing mode." t)
(add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.geom\\'" . glsl-mode))

(defun toggle-text-fold (&optional level)
  "Fold text indented by LEVEL."
  (interactive "P")
  (if (eq selective-display (1+ (current-column)))
      (set-selective-display 0)
    (set-selective-display (or level (1+ (current-column))))))

(global-set-key (kbd "<f2>") #'sr-speedbar-toggle)
(global-set-key (kbd "<f3>") #'toggle-text-fold)

(defun my-c-mode-hook ()
  "C-Style specific properties."
  ;; Default behaviour
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0)  
  (c-set-offset 'case-label 4)

  ;; Company C Headers
  (setq company-c-headers-path-system
        '("/usr/include/c++/9.2.0" 
          "/usr/avr/include"
          "/usr/include"
          "/usr/local/include"))
  (add-to-list 'company-backends 'company-c-headers))

(add-hook 'c-mode-common-hook 'my-c-mode-hook)

(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  :config
  (setq python-shell-interpreter "python3"
        python-shell-interpreter-args "-i"
        elpy-rpc-python-command "python3"))
