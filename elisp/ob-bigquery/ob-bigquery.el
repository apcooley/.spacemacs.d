;;; ob-bigquery.el --- Babel Functions for Google BigQuery -*- lexical-binding: t; -*-

;; Author: Aaron Cooley
;; Keywords: literate programming, reproducible research, bigquery
;; Based on ob-sqlite.el / ob-duckdb.el

;;; Commentary:

;; Org-Babel support for evaluating BigQuery SQL via the `bq' CLI
;; (Google Cloud SDK).
;;
;; Example:
;;
;;   #+begin_src bigquery :project valued-sight-253418 :results table
;;   SELECT name, COUNT(*) AS c
;;   FROM `valued-sight-253418.dataset.table`
;;   GROUP BY 1
;;   LIMIT 10
;;   #+end_src
;;
;; Header arguments:
;;   :project   GCP project ID (else uses bq's default)
;;   :location  BigQuery location (e.g. US, EU)
;;   :max-rows  Max rows to return (default 1000)
;;   :legacy    If non-nil, use legacy SQL (default: standard SQL)
;;   :dry-run   If non-nil, validate query without running it
;;   :colnames  "yes" to keep header row as column names (default yes)
;;
;; The block always uses CSV output internally and converts to an
;; org-mode table when :results is table (the default).

;;; Code:

(require 'org-macs)
(org-assert-version)

(require 'ob)
(require 'ob-sql)

(declare-function org-table-convert-region "org-table"
                  (beg0 end0 &optional separator))
(declare-function org-table-to-lisp "org-table" (&optional txt))

(defvar org-babel-default-header-args:bigquery
  '((:colnames . "yes")
    (:results  . "table")))

(defvar org-babel-header-args:bigquery
  '((project   . :any)
    (location  . :any)
    (max-rows  . :any)
    (legacy    . :any)
    (dry-run   . :any))
  "BigQuery-specific header args.")

(defcustom org-babel-bigquery-command "bq"
  "Path to the `bq' command-line tool."
  :group 'org-babel
  :type 'string)

(defcustom org-babel-bigquery-default-max-rows 1000
  "Default max rows returned by a BigQuery babel block."
  :group 'org-babel
  :type 'integer)

(defun org-babel-expand-body:bigquery (body params)
  "Expand BODY according to the values of PARAMS."
  (let ((prologue (cdr (assq :prologue params)))
        (epilogue (cdr (assq :epilogue params))))
    (mapconcat #'identity
               (delq nil
                     (list prologue
                           (org-babel-sql-expand-vars
                            body (org-babel--get-vars params) t)
                           epilogue))
               "\n")))

(defun org-babel-execute:bigquery (body params)
  "Execute BigQuery BODY according to PARAMS.
Called by `org-babel-execute-src-block'."
  (let* ((result-params (split-string (or (cdr (assq :results params)) "")))
         (project   (cdr (assq :project params)))
         (location  (cdr (assq :location params)))
         (max-rows  (or (cdr (assq :max-rows params))
                        org-babel-bigquery-default-max-rows))
         (legacy    (cdr (assq :legacy params)))
         (dry-run   (cdr (assq :dry-run params)))
         (headers-p (not (equal "no" (cdr (assq :colnames params)))))
         (query     (org-babel-expand-body:bigquery body params))
         (cmd       (mapconcat
                     #'identity
                     (delq nil
                           (list
                            org-babel-bigquery-command
                            (when project
                              (format "--project_id=%s"
                                      (shell-quote-argument
                                       (format "%s" project))))
                            (when location
                              (format "--location=%s"
                                      (shell-quote-argument
                                       (format "%s" location))))
                            "query"
                            (format "--use_legacy_sql=%s"
                                    (if legacy "true" "false"))
                            (format "--max_rows=%d" max-rows)
                            "--format=csv"
                            (when dry-run "--dry_run")
                            "--quiet"
                            (shell-quote-argument query)))
                     " ")))
    (with-temp-buffer
      (insert (org-babel-eval cmd ""))
      (org-babel-result-cond result-params
        (buffer-string)
        (if (equal (point-min) (point-max))
            ""
          (org-table-convert-region (point-min) (point-max) '(4))
          (org-babel-bigquery-table-or-scalar
           (org-babel-bigquery-offset-colnames
            (org-table-to-lisp) headers-p)))))))

(defun org-babel-bigquery-table-or-scalar (result)
  "Cleanup cells in the RESULT table.
If RESULT is a trivial 1x1 table, then unwrap it."
  (if (and (equal 1 (length result))
           (equal 1 (length (car result))))
      (org-babel-read (caar result) t)
    (mapcar (lambda (row)
              (if (eq 'hline row)
                  'hline
                (mapcar (lambda (cell) (org-babel-read cell t)) row)))
            result)))

(defun org-babel-bigquery-offset-colnames (table headers-p)
  "If HEADERS-P is non-nil then offset the first row as column names in TABLE."
  (if headers-p
      (cons (car table) (cons 'hline (cdr table)))
    table))

(defun org-babel-prep-session:bigquery (_session _params)
  "BigQuery sessions are not supported."
  (error "BigQuery sessions are not supported"))

(provide 'ob-bigquery)

;;; ob-bigquery.el ends here
