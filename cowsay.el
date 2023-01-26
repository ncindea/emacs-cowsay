;;; cowsay definitions for Emacs.  (C) Nicolae Cindea
;;; largely inspired by "figlet definitions for Emacs.  (C) Martin Giese"
;;; http://www.figlet.org/figlet.el
;;;
;;; Use this to separate sections in TeX files, Program source, etc.
;;;
;;; customize the cowsay-font-dir variable below to point to your
;;; cows font directory.
;;;
;;; M-x cowsay      to get a cowsay comment in standard font.
;;; C-u M-x cowsay  to be asked for the font first.
;;;
;;; These functions use comment-region to wrap the cowsay output 
;;; in comments.
;;;
;;;  ______________ 
;;; < cowsay stuff >
;;;  -------------- 
;;;         \   ^__^
;;;          \  (oo)\_______
;;;             (__)\       )\/\
;;;                 ||----w |
;;;                 ||     ||



(defconst cowsay-font-dir "/usr/local/share/cows")
(defconst cowsay-font-file-regexp "\\.cow$")
(defconst cowsay-match-font-name-regexp "^\\([^.]*\\)\\.cow$")

(defun cowsay-font-name-for-file (filename)
  (string-match cowsay-match-font-name-regexp filename)
  (match-string 1 filename))

(defun cowsay-font-names ()
  (mapcar 'cowsay-font-name-for-file
	  (directory-files cowsay-font-dir nil cowsay-font-file-regexp)))

(defun read-cowsay-font (prompt)
  (let* ((cowsay-fonts (cowsay-font-names))
	 (font-alist (mapcar (lambda (x) (list x)) cowsay-fonts)))
    (completing-read prompt font-alist)))

(defun call-cowsay (font string)
  (push-mark)
  (call-process "cowsay" nil (current-buffer) nil
		"-f" (if (null font) "default" font)
		string
		)
  (exchange-point-and-mark))

(defun cowsay-block-comment-region ()
  (comment-region (region-beginning) (region-end)
		  (if (member major-mode 
			      '(emacs-lisp-mode
				lisp-mode
				scheme-mode))
		      3			; 3 semicolons for lisp
		    nil)
		  ))

(defun cowsay (s &optional font)
  (interactive 
   (if current-prefix-arg
       (let 
	   ((font (read-cowsay-font "Font: "))
	    (text (read-string "Cowsay Text: ")))
	 (list text font))
     (list (read-string "Cowsay Text: ") nil)))
  (save-excursion
    (call-cowsay font s)
    (cowsay-block-comment-region)
    ))
    
