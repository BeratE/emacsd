;;; package --- Summary
;;; Basic Emacs Init file. Load settings.org.

;;; Commentary:

;;; Code:
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
(require 'use-package)


;; Load Configuration file
(require 'org)
(org-babel-load-file
 (expand-file-name "settings.org"
		   user-emacs-directory))


;;; init.el ends here


