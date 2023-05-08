;;; package --- Summary
;;; Basic Emacs Init file. Load settings.org.


(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(package-initialize)

;; Make sure that use-package is installed:
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; Load use-package:
(eval-when-compile
  (require 'use-package))

;; Load Configuration file
(require 'org)
(org-babel-load-file
 (expand-file-name "settings.org"
		   user-emacs-directory))
(put 'downcase-region 'disabled nil)
