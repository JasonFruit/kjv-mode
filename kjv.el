;;; kjv.el --- Minor mode to insert text, Markdown, LaTeX, or HTML
;;; Bible passages

;; Copyright: (C) 2020 Jason R. Fruit
;; URL: https://github.com/JasonFruit/kjv-mode
;; Version: 1.0

;;
;;     This program is free software; you can redistribute it and/or
;;     modify it under the terms of the GNU General Public License as
;;     published by the Free Software Foundation; either version 2 of
;;     the License, or (at your option) any later version.
;;     
;;     This program is distributed in the hope that it will be useful,
;;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;     GNU General Public License for more details.
;;     
;;     You should have received a copy of the GNU General Public License
;;     along with GNU Emacs; if not, write to the Free Software
;;     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;;     02110-1301 USA

;;; Commentary
;;
;; To use this minor mode, you must have the `kjv` command-line
;; utility properly installed and on your PATH.  `kjv` can be
;; retrieved from: https://github.com/JasonFruit/kjv
;;
;; To install kjv.el, save this file somewhere in your Emacs load path
;; and put the following in your .emacs:
;;
;;   (require 'kjv)
;;
;; To toggle kjv-mode, which is initially off, do:
;;
;;   M-x kjv-mode
;;
;; Once kjv-mode is active, the following default keybindings will be
;; created:
;;
;;   C-c C-i: insert a passage
;;   C-c C-o: choose a different format (plain text, Markdown, LaTeX,
;;            or HTML)
;;   C-c C-p: search for a phrase
;;   C-c C-m: search for multiple words

(defun kjv-insert-passage (key)
  "Insert a passage by reference into the current buffer."
  (interactive "sKey: ")

  (make-variable-buffer-local 'kjv-format)
  
  (shell-command (concat "kjv -"
			 (cond ((equal kjv-format "plain") "p")
			       ((equal kjv-format "latex") "l")
			       ((equal kjv-format "markdown") "d")
			       ((equal kjv-format "html") "m")
			       (t "p"))
			 "=\"" key "\"") 1))

(defun kjv-auto-set-format ()
  (interactive)
  (setq kjv-format
	(let ((ext (file-name-extension (buffer-file-name))))
	  (cond ((equal ext "tex") "latex")
		((equal ext "html") "html")
		((equal ext "htm") "html")
		((equal ext "xhtml") "html")
		((equal ext "txt") "plain")
		((equal ext "md") "markdown")
		((equal ext "rst") "plain")
		(t "plain")))))

(defun kjv-choose-format ()
  "Choose a format to present Bible text in."
  (interactive)
  (let ((choices '("html" "latex" "markdown" "plain")))
    (setq kjv-format (minibuffer-with-setup-hook 'minibuffer-complete
		       (completing-read "Format: "
					choices nil t)))))

(defun kjv-choose-result (results)
  "Choose a reference from a set of search results."
    (kjv-insert-passage (minibuffer-with-setup-hook 'minibuffer-complete
			  (completing-read "Verse: "
					   results nil t))))

(defun kjv-search (key type)
  "Do a search of the specified type for the key."
  (let ((results
	 (with-temp-message "Retrieving search results . . ."
	   (split-string (shell-command-to-string
			  (concat "kjv --" type "=\"" key "\""))
			 "\n"))))
    (kjv-choose-result results)))

(defun kjv-multiword-search (key)
  "Do a multiword search."
  (interactive "sSearch terms: ")
  (kjv-search key "words"))

(defun kjv-phrase-search (key)
  "Do a phrase search."
  (interactive "sSearch terms: ")
  (kjv-search key "phrase"))

;; (defun kjv-regex-search (key)
;;   "Do a search by regular expression."
;;   (interactive "sSearch terms: ")
;;   (kjv-search key "regex"))

(provide 'kjv)

(define-minor-mode kjv-mode
  "Toggle kjv-mode.

     With no argument, this command toggles the mode.  Non-null
     prefix argument turns on the mode.  Null prefix argument
     turns off the mode.
     
     When kjv-mode is enabled, several keybindings are made
     to insert bible passages by several kinds of search and by
     reference.

     Also, the variable kjv-bible is set to the name of the
     alphabetically first kjv module."
  
  ;; The initial value.
  :init-value nil
  ;; The indicator for the mode line.
  :lighter " kjv"
  ;; The minor mode bindings.
  :keymap
  '(("\C-\c\C-i" . kjv-insert-passage)
    ("\C-\c\C-o" . kjv-choose-format)
    ("\C-\c\C-p" . kjv-phrase-search)
    ("\C-\c\C-m" . kjv-multiword-search)
    ("\C-\c\C-a" . kjv-auto-set-format))
  :after-hook
  (kjv-auto-set-format))
;;; kjv.el ends here
