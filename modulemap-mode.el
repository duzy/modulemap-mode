;;; modulemap-mode.el --- modulemap file editing commands for Emacs -*- lexical-binding:t -*-

;; Copyright (C) 2016 Duzy Chan <code@duzy.info>, http://duzy.info

;; Author: Duzy Chan <code@duzy.info>
;; Maintainer: code@duzy.info
;; Keywords: unix, tools
(require 'cc-mode)

(defgroup modulemap nil
  "Modulemap editing commands for Emacs."
  :link '(custom-group-link :tag "Font Lock Faces group" font-lock-faces)
  :group 'tools
  :prefix "modulemap-")

;; http://raebear.net/comp/emacscolors.html
(defface modulemap-indent-face
  '((((class color) (background light)) :background "gray88" :italic t)
    (((class color) (background dark)) :background "LightDim" :italic t)
    (t :inherit font-lock-constant-face))
  "Face to use for additionally highlighting rule targets in Font-Lock mode."
  :group 'modulemap)

(defface modulemap-comment-face ; //...
  '((t :inherit font-lock-comment-face))
  "Face to used to highlight comments."
  :group 'smart)

(defface modulemap-module-name-face ;font-lock-type-face
  '((t :inherit font-lock-variable-name-face)) ;; :background  "LightBlue1"
  "Face to use for additionally highlighting rule targets in Font-Lock mode."
  :group 'modulemap)

(defface modulemap-property-face
  '((t :inherit font-lock-builtin-face))
  "Face name to use for modulemap properties."
  :group 'modulemap)

(defface modulemap-export-name-face
  '((t :inherit font-lock-constant-face))
  "Face name to use for modulemap export names."
  :group 'modulemap)

(defface modulemap-keyword-face
  '((t :inherit font-lock-keyword-face))
  "Face name to use for modulemap keywords."
  :group 'modulemap)

(defconst modulemap-keywords
  `("module" "export" "header"
    ;;,@(cdr makefile-statements)
    )
  "List of keywords understood by modulemap.")

(defconst modulemap-keywords-regex
  (regexp-opt modulemap-keywords 'words)
  "Regex to match keywords understood by modulemap.")

;; example: makefile-make-font-lock-keywords
(defconst modulemap-font-lock-keywords
  `(("\\(module\\)\\s-+\\(\\(?:[a-zA-Z0-9_]\\)+\\)"
     (1 'modulemap-keyword-face)
     (2 'modulemap-module-name-face))

    ("\\(export\\)\\s-+\\(\\(?:[a-zA-Z0-9_*]\\)+\\)"
     (1 'modulemap-keyword-face)
     (2 'modulemap-export-name-face))

    ("\\(\\[\\)\\(\\(?:[a-zA-Z0-9_]\\|\\s-+\\)+\\)\\(\\]\\)"
     (1 'modulemap-property-face)
     (2 'modulemap-property-face)
     (3 'modulemap-property-face))

    ;;(,modulemap-keywords-function
    ;; (1 ...))

    (,modulemap-keywords-regex
     (1 'modulemap-keyword-face))))

(defcustom modulemap-mode-hook nil
  "Normal hook run by `modulemap-mode'."
  :type 'hook
  :group 'modulemap)

(defvar modulemap-mode-map ;; See `makefile-mode-map'
  (let ((map (make-sparse-keymap))
	(opt-map (make-sparse-keymap)))
    ;;(define-key map "\M-p"     'modulemap-previous-dependency)
    ;;(define-key map "\M-n"     'modulemap-next-dependency)
    ;;(define-key map "\n"       'modulemap-newline) ;; C-j
    ;;(define-key map "\t"       'modulemap-tab-it)  ;; C-i or <tab>
    map)
  "The keymap that is used in Modulemap mode.")

(defvar modulemap-mode-syntax-table
  (let ((st (make-syntax-table)))
    ;; comment style “/* … */”
    (modify-syntax-entry ?\/ ". 14" st)
    (modify-syntax-entry ?* ". 23" st)

    ;; C++ style comment “// …”
    (modify-syntax-entry ?\/ ". 12b" st)
    (modify-syntax-entry ?\n "> b" st)

    ;; comment “(* … *)”
    ;;(modify-syntax-entry ?\( ". 1" st)
    ;;(modify-syntax-entry ?\) ". 4" st)
    ;;(modify-syntax-entry ?* ". 23" st)

    st)
  "Syntax table used in `modulemap-mode'. (see `c-mode-syntax-table')")

;;(c-define-abbrev-table 'modulemap-mode-abbrev-table
;;  '(("else" "else" c-electric-continued-statement 0)
;;    ("while" "while" c-electric-continued-statement 0))
;;  "Abbreviation table used in modulemap-mode buffers.")

;;;###autoload
(define-derived-mode modulemap-mode prog-mode "modulemap"
  "Major mode for editing .modulemap files."
  ;;:syntax-table modulemap-mode-syntax-table
  ;;:after-hook (c-update-modeline)

  (setq-local font-lock-defaults `(modulemap-font-lock-keywords ,@(cdr font-lock-defaults)))
  (use-local-map modulemap-mode-map)

  ;; Comment stuff.
  ;;(setq-local comment-start "//")
  ;;(setq-local comment-end "")
  ;;(setq-local comment-start-skip "//+[ \t]*")

  ;;(c-initialize-cc-mode t)
  ;;(set-syntax-table modulemap-mode-syntax-table)
  ;;(c-init-language-vars 'modulemap-mode)
  ;;(c-common-init 'modulemap-mode)
  (c-run-mode-hooks 'modulemap-mode-hook))

;;;###autoload (add-to-list 'auto-mode-alist '("\\.modulemap\\'" . modulemap-mode))

;;; The End.

(provide 'modulemap-mode)

;;; modulemap-mode.el ends here
