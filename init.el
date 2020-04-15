;;; package --- Summary
;;; Commentary:
;;;

;;;
;;; Code:
;;;

;;;
;;; Default Behaviour
;;;

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(setq inhibit-startup-screen t
      indent-tabs-mode nil)
(tool-bar-mode -1)
(menu-bar-mode -1)
(column-number-mode t)
(show-paren-mode t)
(global-linum-mode t)

;; Bug in Emacs (Bad Request)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Optimization
(setq gc-cons-threshold 100000000 ;  100mb
      read-process-output-max (* 1024 1024)) ; 1 mb

;;;
;;; Package Settings
;;;

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'load-path "~/.emacs.d/elpa")
;; Third party elisp files
;; Add all subdirs contained in the following directory
(let ((default-directory  "~/.emacs.d/site-lisp/"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

(package-initialize)

;;;
;;; Global Modes
;;;

;; Which-key
(require 'which-key)
(which-key-mode)

;; Projectile
(require 'projectile)
(projectile-mode t)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0)

;; Flycheck
(require 'flycheck)
(add-hook 'after-init-hook 'global-flycheck-mode)

;; Yassnippet
(require 'yasnippet)
(require 'yasnippet-snippets)
(yas-global-mode 1)


;; undo-tree
(require 'undo-tree)
(undo-tree-mode)
(global-set-key (kbd "M-/") 'undo-tree-visualize)

;; sr-speedbar
(require 'speedbar)
(setq speedbar-show-unknown-files t)

;; Smartparens
(require 'smartparens-config)
(add-hook 'after-init-hook 'smartparens-mode)

;; LSP
(setq lsp-keymap-prefix "C-c l")
(require 'lsp-mode)
(setq lsp-enable-indentation nil) ; messes up my config
(add-hook 'prog-mode-hook #'lsp)
(setq lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error"))
;; Note: Clang looks for compile_commands.json in project root folder
(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

;; Company-LSP
(require 'company-lsp)
(push 'company-lsp company-backends)

;; GDB
(setq gdb-many-windows t)

;; CMake
(require 'cmake-mode)

;;;
;;; (Language) Specific Modes
;;;

;; Elpy
(elpy-enable) ; Does call into a hook, no automatic invocation.
(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i"
      elpy-rpc-python-command "python3")
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Lua Mode
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
(setq lua-indent-level 2)

;; GLSL Mode
(autoload 'glsl-mode "glsl-mode" "GLSL Editing mode." t)
(add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.geom\\'" . glsl-mode))

;; Web Mode
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-omode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\.twig\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; Org-mode settings
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(setq org-log-done t)
; Babel in org-mode
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (ipython . t)
   (shell . t)))
(setq org-src-fontify-natively t)
(setq org-confirm-babel-evaluate nil)
(setq ob-async-no-async-languages-alist '("ipython"))

;; Slime
(require 'slime)
(load "~/quicklisp/clhs-use-local.el" t)
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "/usr/bin/sbcl")
(add-hook 'lisp-mode-hook #'slime-mode)

;; Assembler
(require 'rgbds-mode)
(add-to-list 'auto-mode-alist '("\\.inc\\'" . asm-mode))

;;;
;;; Custom functions and global keybindings
;;;

(defun toggle-text-fold (&optional level)
  "Fold text indented by LEVEL."
  (interactive "P")
  (if (eq selective-display (1+ (current-column)))
      (set-selective-display 0)
    (set-selective-display (or level (1+ (current-column))))))

(global-set-key (kbd "<f2>") #'sr-speedbar-toggle)
(global-set-key (kbd "<f3>") #'toggle-text-fold)

;;;
;;; Custom Mode Hooks and Configurations
;;;



(defun my-c-mode-hook ()
  "C-Style specific properties."
  ;; Default behaviour
  (c-set-style "linux")
  (setq c-basic-offset 4)
  ;; Company C Headers
  (setq company-c-headers-path-system '("/usr/include/c++/9.2.0" "/usr/include" "/usr/local/include"))
  (add-to-list 'company-backends 'company-c-headers))

(add-hook 'c-mode-common-hook 'my-c-mode-hook)

;;; init ends here
