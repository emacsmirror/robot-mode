;;; robot-mode.el --- Robot framework major-mode

;; Copyright (C) 2020 Kalle Kankare

;; Author: Kalle Kankare <kalle.kankare@iki.fi>
;; Maintainer: Kalle Kankare <kalle.kankare@iki.fi>
;; Created: 26 Nov 2020
;; Keywords: major-mode
;; Version: 0.1.0
;; Package-Requires: ((emacs "26.1"))

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; TODO

;;; Code:

(require 'align)

(defgroup robot-mode nil
  ""
  )

(defcustom robot-mode-basic-offset standard-indent
  "")

(defcustom robot-mode-field-separator standard-indent
  "")

(defvar robot-mode-font-lock-keywords
  '(("#.*" . font-lock-comment-face)
    ("^\\*.*" . font-lock-keyword-face)
    ("\\[\\sw+\\]" . font-lock-constant-face)
    ("\\.\\.\\." . font-lock-constant-face)
    ("^\\(Library\\|Resource\\|Suite Setup\\|Suite Teardown\\):?\s-*\\(.*\\)"
     (1 font-lock-preprocessor-face t) (2 font-lock-constant-face t))
    ("^\\(Documentation\\|Tags\\|Metadata\\):?\s-*\\(.*\\)"
     (1 font-lock-preprocessor-face t) (2 font-lock-string-face t))
    ("[@$&%]{\\([0-9]+\\|true\\|false\\)}" . font-lock-constant-face)
    ("[@$&%]{[^}]*}" . font-lock-variable-name-face)
    ("^[^ \t].*" . font-lock-function-name-face))
  "")

(defvar robot-mode-syntax-table
  (with-syntax-table (make-syntax-table)
    (modify-syntax-entry ?# "<")
    (modify-syntax-entry ?\n ">")
    (syntax-table))
  "")

(defvar robot-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-a") #'robot-mode-align-defun)
    map)
  "")

(defun robot-mode-syntax-propertize (start end)
  (funcall
   (syntax-propertize-rules
    ;; Single space between non-space characters is part of the symbol syntax
    ("\\([^ ] [^ ]\\)" (1 "_")))
   start end))

(defun robot-mode--back-to-previous-line ()
  "Get to the previous non-empty line"
  (beginning-of-line)
  (re-search-backward "^\\s-*[[:print:]]" nil t)
  (back-to-indentation))

(defun robot-mode-indent-line ()
  ""
  (interactive)
  (let* ((indent 0)
	 ;; Get the current section
	 (section
	  (downcase (or (save-excursion
			 (re-search-backward "^\\s-*\\*+\\s-*\\([a-zA-Z ]+\\)" nil t)
			 (match-string-no-properties 1)) "")))
	 ;; function to get the previous non-empty line
	 (back-to-previous-line
	  (lambda ()
	    (beginning-of-line)
	    (re-search-backward "^\\s-*[[:print:]]" nil t)
	    (back-to-indentation)))
	 ;; The amount of indent of previous non-empty line
	 (previous-indent
	  (save-excursion
	    (funcall back-to-previous-line)
	    (- (point) (line-beginning-position)))))

    (cond ((not (string-match "task.*\\|test case.*\\|keyword.*" section))
	   ;; Indent only lines in the above sections
	   (setq indent 0))

	  ;; Header line should not be indented
	  ((save-excursion
	     (back-to-indentation)
	     (looking-at "\\*"))
	   (setq indent 0))

	  ;; Indent only lines that are inside keywords
	  ((= previous-indent 0)
	   (save-excursion
	     (funcall back-to-previous-line)
	     (setq indent
		   ;; If the previous line is not a header
		   (cond ((not (looking-at "^\\*"))
			  robot-mode-basic-offset)
			 (t 0)))))
	  (t
	   ;; If previous line is indented, indent to that level
	   (setq indent previous-indent)))

    ;; Toggle indentation if the line is already indented
    (when (and (> indent 0)
	       (= indent (- (point) (line-beginning-position))))
      (setq indent 0))

    ;; Do the actual indenting
    (back-to-indentation)
    (delete-region (line-beginning-position)  (point))
    (indent-to indent)))

(defun robot-mode-beginning-of-defun (&optional args)
  ""
  (re-search-backward "^\\S-" nil t))

(defun robot-mode-end-of-defun (&optional args)
  ""
  ;; If at the beginning of the defun
  (when (looking-at "^\\S-")
    (forward-char))

  (re-search-forward "^\\S-" nil t)
  (robot-mode--back-to-previous-line)
  (forward-line)
)

(defun robot-mode-align (beg end)
  ""
  (interactive
   (list (region-beginning) (region-end)))

  (message "begin %d end %d" beg end)

  (let ((align-to-tab-stop nil))
    (align-regexp beg end "\\(\\s-\\s-+\\)"  1 robot-mode-field-separator t))
  (indent-region beg end)
)

(defun robot-mode-align-defun ()
  ""
  (interactive)
  (let ((beg (save-excursion
		(beginning-of-defun)
		(forward-line)
		(point)))
	(end (save-excursion
	       (end-of-defun)
	       (point))))
    (robot-mode-align beg end)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.\\(resource\\|robot\\)\\'" . robot-mode))

;;;###autoload
(define-derived-mode robot-mode prog-mode "Robot"
  "Major mode for editing Robot framework files

\\{robot-mode-map}"

  (setq-local indent-line-function #'robot-mode-indent-line)
  (setq-local font-lock-defaults '(robot-mode-font-lock-keywords nil t))
  (setq-local comment-start "#")
  (setq-local beginning-of-defun-function #'robot-mode-beginning-of-defun)
  (setq-local end-of-defun-function #'robot-mode-end-of-defun)
  (setq-local syntax-propertize-function #'robot-mode-syntax-propertize)
  (setq-local outline-regexp "^\\*\\*\\*\\|^\\sw"))

;;; robot-mode.el ends here
