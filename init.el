;;; package --- Summary
;;; Basic Emacs Init file. Load settings.org.


(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(package-initialize)

(require 'use-package)

;; Load Configuration file
(require 'org)
(org-babel-load-file
 (expand-file-name "settings.org"
		   user-emacs-directory))


;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(magit paredit cider clojure-mode fold-this cmake-mode treemacs-projectile dap-mode helm-xref projectile helm-lsp yasnippet ggtags sr-speedbar company-irony-c-headers company-c-headers company lsp-treemacs helm org-special-block-extras flycheck auctex lsp-haskell lsp-ui lsp-mode which-key use-package))
 '(safe-local-variable-values '((TeX-command-extra-options . "-shell-escape")))
 '(show-trailing-whitespace nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
