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
