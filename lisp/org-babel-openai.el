;;; org-babel-openai.el --- Org Babel support for openai.el -*- lexical-binding: t; -*-

(require 'org)
(require 'ob)
(require 'openai nil t)

(defgroup ob-openai nil
  "Org Babel functions for OpenAI via openai.el."
  :group 'org-babel)

(defcustom ob-openai-timeout-seconds 60
  "How long `org-babel-execute:openai' waits for a response."
  :type 'integer
  :group 'ob-openai)

(defcustom ob-openai-default-model nil
  "Default model to use when :model is not provided.
If nil, openai.el's default is used."
  :type '(choice (const :tag "Use openai.el default" nil) string)
  :group 'ob-openai)

(defvar org-babel-default-header-args:openai
  '((:results . "raw")
    (:exports . "both"))
  "Default header args for openai blocks.")

(defun ob-openai--as-number (x)
  (cond ((numberp x) x)
        ((and (stringp x) (string-match-p "\\`[0-9]+\\(\\.[0-9]+\\)?\\'" x)) (string-to-number x))
        (t nil)))

(defun ob-openai--extract-text (data)
  "Try hard to extract the generated text from openai.el callback DATA."
  (cond
   ((stringp data) data)
   ((and (listp data) (alist-get 'choices data))
    (let* ((choices (alist-get 'choices data))
           (first (and (listp choices) (car choices))))
      (or (alist-get 'text first)
          (alist-get 'content (alist-get 'message first))
          (format "%S" data))))
   ((and (listp data) (plist-get data :choices))
    (let* ((choices (plist-get data :choices))
           (first (and (listp choices) (car choices))))
      (or (plist-get first :text)
          (plist-get (plist-get first :message) :content)
          (format "%S" data))))
   (t (format "%S" data))))

(defun org-babel-execute:openai (body params)
  "Execute an OpenAI prompt in Org Babel using openai.el.

BODY is the prompt text.
PARAMS supports:
  :model        string
  :max-tokens   number
  :temperature  number
  :top-p        number
  :stop         string (or a lisp list if you pass it via :var)
  :key          string (optional override)
  :user         string (optional override)
  :raw          \"t\" to return raw DATA printed, else extract text"
  (unless (featurep 'openai)
    (error "openai.el is not available (require 'openai' failed)"))

  (let* ((model (or (cdr (assoc :model params)) ob-openai-default-model))
         (max-tokens (ob-openai--as-number (cdr (assoc :max-tokens params))))
         (temperature (ob-openai--as-number (cdr (assoc :temperature params))))
         (top-p (ob-openai--as-number (cdr (assoc :top-p params))))
         (stop (cdr (assoc :stop params)))
         (key (cdr (assoc :key params)))
         (user (cdr (assoc :user params)))
         (raw (cdr (assoc :raw params)))

         (done nil)
         (err nil)
         (data nil)
         (start-time (float-time)))

    (openai-completion
     body
     (lambda (d)
       (setq data d)
       (setq done t))
     ;; optional keyword args
     ;; only pass what we have (openai.el tolerates missing keys)
     ;; note: stop can be string or list depending on openai.el version
     :model (or model (ignore))
     :max-tokens (or max-tokens (ignore))
     :temperature (or temperature (ignore))
     :top-p (or top-p (ignore))
     :stop (or stop (ignore))
     :key (or key (ignore))
     :user (or user (ignore)))

    (while (and (not done)
                (< (- (float-time) start-time) ob-openai-timeout-seconds))
      (accept-process-output nil 0.1))

    (when (not done)
      (error "OpenAI request timed out after %ss" ob-openai-timeout-seconds))

    (when err
      (error "%s" err))

    (if (and raw (stringp raw) (string= raw "t"))
        (format "%S" data)
      (string-trim-right (ob-openai--extract-text data)))))

(provide 'org-babel-openai)
;;; org-babel-openai.el ends here
