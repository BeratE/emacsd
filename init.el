;;; package --- Summary
;;; Commentary:
;;;

;;;
;;; Code:
;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(ein:polymode t)
 '(package-selected-packages
   (quote
    (multicolumn cmake-mode company-rtags cmake-ide rtags clang-format company-c-headers sr-speedbar w3m slime-company smartparens slime ctags-update projectile ein elpy yasnippet-classic-snippets web-mode php-auto-yasnippets pdf-tools lua-mode gnuplot-mode gnuplot flycheck auctex)))
 '(sp-base-key-bindings (quote sp)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;; Default Behaviour
(setq-default c-basic-offset 4)
(setq inhibit-startup-screen t)
(setq column-number-mode t)
(setq indent-tabs-mode nil)
(show-paren-mode 1)
(global-linum-mode t)

;;; Common Lisp Hyperspec
(load "~/quicklisp/clhs-use-local.el" t)

;; Bug in Emacs (Bad Request)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;;;
;;; Custom functions and global Keybindings
;;;

(defun toggle-text-fold (&optional level)
  "Fold thext indented by LEVEL."
  (interactive "P")
  (if (eq selective-display (1+ (current-column)))
      (set-selective-display 0)
    (set-selective-display (or level (1+ (current-column))))))

(global-set-key (kbd "<f2>") #'sr-speedbar-toggle)
(global-set-key (kbd "<f3>") #'toggle-text-fold)
(global-set-key (kbd "<f5>") #'compile)

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

;; Projectile
(require 'projectile)
(define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)

;; Company
(require 'company)
(setq company-c-headers-path-system '("/usr/include/c++/9.2.0" "/usr/include" "/usr/local/include"))
(add-to-list 'company-backends 'company-c-headers)
(add-hook 'after-init-hook 'global-company-mode)

;; Flycheck
(require 'flycheck)
(add-hook 'after-init-hook 'global-flycheck-mode)


;; Yassnippet
(require 'yasnippet)

;; RTags
(require 'rtags)

;; Cmake-IDE
(require 'cmake-ide)
(cmake-ide-setup)
(setq cmake-ide-flags-c++ (append '("-std=c++11")))

;; RTags Config
(setq rtags-autostart-diagnostics t)
(rtags-diagnostics)
(setq rtags-completions-enabled t)
(rtags-enable-standard-keybindings)
;(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
;(add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
;(add-hook 'objc-mode-hook 'rtags-start-process-unless-running)

(require 'company-rtags)
(setq rtags-completions-enabled t)
(push 'company-rtags company-backends)

(require 'flycheck-rtags)

;; Elpy
(elpy-enable)
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
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\.twig\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; Slime
(require 'slime)
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "/usr/bin/sbcl")
(add-hook 'lisp-mode-hook #'slime-mode)

;; sr-speedbar
(require 'speedbar)
(setq speedbar-show-unknown-files t)

;; aspell
(setq ispell-programm-name "aspell")
(setq ispell-dictionary "english")

;; Smartparens
(require 'smartparens)
(add-hook 'after-init-hook #'smartparens-mode)

(require 'cmake-mode)

;;; init ends here
