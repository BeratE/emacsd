;;; package --- Summary
;;; Commentary:
;;;

;;;
;;; Code:
;;;

(custom-set-variables
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(beacon-color "#f2777a")
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(custom-safe-themes (quote
                       ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a"
                        "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d"
                        "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58"
                        "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e"
                        "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" default)))
 '(fci-rule-color "#515151")
 '(flycheck-color-mode-line-face-to-color (quote mode-line-buffer-id))
 '(frame-background-mode (quote dark))
 '(package-selected-packages
   (quote (color-theme-sanityinc-tomorrow multiple-cursors multicolumn
           cmake-mode company-rtags cmake-ide rtags clang-format company-c-headers sr-speedbar
           w3m slime-company smartparens slime ctags-update projectile ein elpy yasnippet-classic-snippets
           web-mode php-auto-yasnippets pdf-tools lua-mode gnuplot-mode gnuplot flycheck auctex)))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#f2777a")
     (40 . "#f99157")
     (60 . "#ffcc66")
     (80 . "#99cc99")
     (100 . "#66cccc")
     (120 . "#6699cc")
     (140 . "#cc99cc")
     (160 . "#f2777a")
     (180 . "#f99157")
     (200 . "#ffcc66")
     (220 . "#99cc99")
     (240 . "#66cccc")
     (260 . "#6699cc")
     (280 . "#cc99cc")
     (300 . "#f2777a")
     (320 . "#f99157")
     (340 . "#ffcc66")
     (360 . "#99cc99"))))
 '(vc-annotate-very-old-color nil)
 '(window-divider-mode nil))
(custom-set-faces
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal
                :weight semi-bold :height 98 :width normal)))))


;;;
;;; Default Behaviour
;;;

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
(require 'smartparens)
(add-hook 'after-init-hook 'smartparens-mode)

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
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "/usr/bin/sbcl")
(add-hook 'lisp-mode-hook #'slime-mode)

;;;
;;; Custom Mode Hooks and Configurations
;;;

(defun my-c-mode-common-hook ()
  "Customizations for all of c-mode and related modes."
  ;; Default behaviour
  (setq-default c-basic-offset 4)
  ;; Company C Headers
  (add-to-list 'company-backends 'company-c-headers)
  ;; RTags
  (require 'rtags)
  (require 'company-rtags)
  (require 'flycheck-rtags)
  (setq rtags-autostart-diagnostics t)
  (setq rtags-completions-enabled t)
  (rtags-enable-standard-keybindings)
  ;; Setup rtags company backend
  (setq rtags-completions-enabled t)
  (push 'company-rtags company-backends)
  ;; Setup Rtags flycheck for better experience
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-check-syntax-automatically nil)
  (setq-local flycheck-highlighting-mode nil)
  ;; CMake IDE
  (cmake-ide-setup)
  (rtags-start-process-unless-running)
  )

(defun my-lisp-mode-hook ()
  ;;; Offline Common Lisp Hyperspec
  (load "~/quicklisp/clhs-use-local.el" t)
  )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-hook 'slime-lisp-mode-hook 'my-lisp-mode-hook)

;;; init ends here
