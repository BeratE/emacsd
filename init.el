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

;(setq inhibit-startup-screen t)
(setq column-number-mode t)
(setq indent-tabs-mode nil)
(show-paren-mode t)
(global-linum-mode t)

;; Bug in Emacs (Bad Request)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

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
;;; Package Settings
;;;

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'load-path "~/.emacs.d/elpa")
(let ((default-directory  "~/.emacs.d/lisp/"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))
(package-initialize)

;;;
;;; Global Modes
;;;

;; Projectile
(require 'projectile)
(projectile-mode t)
(define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)

;; Company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; Flycheck
(require 'flycheck)
(add-hook 'after-init-hook 'global-flycheck-mode)

;; Yassnippet
(require 'yasnippet)
(add-hook 'after-init-hool 'yas-global-mode)

;; sr-speedbar
(require 'speedbar)
(setq speedbar-show-unknown-files t)

;; Smartparens
(require 'smartparens-config)
(add-hook 'after-init-hook 'smartparens-mode)
(add-hook 'prog-mode-hook 'turn-on-smartparens-strict-mode)

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

;; Slime
(require 'slime)
(load "~/quicklisp/clhs-use-local.el" t)
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "/usr/bin/sbcl")
(add-hook 'lisp-mode-hook #'slime-mode)

;;;
;;; Custom Mode Hooks and Configurations
;;;

(defun my-c-mode-hook ()
  ;; Default behaviour
  (setq c-default-style "linux"
        c-basic-offset 4)
  ;; Company C Headers
  (setq company-c-headers-path-system '("/usr/include/c++/9.2.0" "/usr/include" "/usr/local/include"))
  (add-to-list 'company-backends 'company-c-headers)
  ;; RTags
  (require 'rtags)
  (require 'company-rtags)
  ;(require 'flycheck-rtags)
  (setq rtags-autostart-diagnostics t)
  (setq rtags-completions-enabled t)
  (rtags-enable-standard-keybindings)
  ;; Setup rtags company backend
  (setq rtags-completions-enabled t)
  (push 'company-rtags company-backends)
  ;; Setup Rtags flycheck for better experience
  ;(setq flycheck-check-syntax-automatically nil)
  ;(setq flycheck-highlighting-mode nil)
  ;(flycheck-select-checker 'rtags)
  ;; CMake IDE
  (cmake-ide-setup)
  (rtags-start-process-unless-running))

(add-hook 'c-mode-common-hook 'my-c-mode-hook)

;;; init ends here
3
