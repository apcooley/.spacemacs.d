;; faster project indexing
(setq projectile-indexing-method 'alien)

;; custom packages not from ELPA/MELPA
(add-to-list 'load-path "~/.spacemacs.d/elisp/ob-duckdb/")
(require 'ob-duckdb)

;; temporary file directory
(setq temporary-file-directory "~/TEMP/")

;; sql lsp-mode
(use-package lsp-mode
  :ensure t
  :config
  (setq lsp-sqls-server '("sql-language-server" "up" "--method" "stdio")))

;; Stay in evil mode
(setq evil-escape-key-sequence nil)

;; Show .Rmd in markdown mode
(add-to-list 'auto-mode-alist '("\\.Rmd\\'" . markdown-mode))

;; For use with org-reveal
(with-eval-after-load 'sgml-mode
  (require 'emmet-mode)
  (add-hook 'sgml-mode-hook #'emmet-mode)
  (add-hook 'css-mode-hook #'emmet-mode))

(with-eval-after-load 'sql
  (setq sql-comint-go-regexp "^GO[ \t]*$")
  (setq sql-ms-program "sqlcmd")
  (setq sql-ms-options '("-E"))
  (setq sql-server "RiskLiveSQL")
  (setq sql-database "ViveDWDB")
  (setq sql-user nil)
  (setq sql-password nil)
  (setq sql-pop-to-buffer-after-send-region t))

;; Custom keybindings
(spacemacs/set-leader-keys
  "f R" 'recover-this-file
  "f n" 'spacemacs/rename-current-buffer-file)

(spacemacs-bootstrap/init-which-key)

(which-key-add-key-based-replacements
  "SPC f n" "Rename"
  "SPC f R" "Recover")

(spacemacs/set-leader-keys-for-major-mode 'clojure-mode
  "s s" 'cider-switch-to-repl-buffer)

(spacemacs/set-leader-keys-for-major-mode 'org-mode
  "g" 'org-todo
  "|" 'org-columns)

(with-eval-after-load 'paredit
  (define-key paredit-mode-map (kbd "RET") nil)
  (add-hook 'cider-repl-mode-hook
            (lambda ()
              (local-set-key (kbd "RET") 'cider-repl-newline-and-indent)
              (local-set-key (kbd "C-RET") 'cider-repl-return))))

;; Access Python virtual environment keybindings from org-mode
(add-to-list 'spacemacs--python-pipenv-modes 'org-mode)

;; Don't autopopulate numbers
(setq company-dabbrev-char-regexp "[A-z:-]")

;; Fixes for ESS-R mode
(add-hook 'ess-r-mode-hook #'lsp)

(with-eval-after-load 'lsp-mode
  (require 'lsp-r)
  (add-hook 'ess-r-mode-hook #'lsp))

(setq lsp-prefer-flymake nil)
(setq lsp-log-io t)
(add-hook 'ess-r-mode-hook (lambda () (flycheck-mode -1)))

;; Org root (single source of truth)
(defconst my/org-home "/home/aaron/org/my-org/"
  "Root directory for Org files on this machine.")

(unless (file-directory-p my/org-home)
  (warn "Org home does not exist: %s" my/org-home))

;; All Org-specific config must wait until Org is loaded (Spacemacs lazy-load).
(with-eval-after-load 'org

  ;; --- Org-mode UX ---
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)

  (add-hook 'org-mode-hook #'visual-line-mode)
  (add-hook 'org-mode-hook #'variable-pitch-mode)

  (use-package org-superstar
    :ensure t
    :after org
    :hook (org-mode . org-superstar-mode)
    :config
    (setq org-superstar-item-bullet-alist '((?- . ?•) (?+ . ?•) (?* . ?•)))
    (setq org-superstar-remove-leading-stars t))

  ;; --- Structure templates ---
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("r"  . "src R"))
  (add-to-list 'org-structure-template-alist '("clj" . "src clojure"))
  (add-to-list 'org-structure-template-alist '("sql" . "src sql"))

  ;; --- Font setup (fixed; matches the "works" behavior) ---

  (defun my/font-tuple (font-candidates family-fallback warn-msg)
    "Return plist like (:font \"Name\") or (:family \"Family\"), or nil."
    (or (seq-some (lambda (f) (when (x-list-fonts f) (list :font f)))
                  font-candidates)
        (when (x-family-fonts family-fallback)
          (list :family family-fallback))
        (progn (warn "%s" warn-msg) nil)))

  (defun my/org-font-tuples ()
    (let ((body
           (my/font-tuple
            '("Crimson" "Crimson Text" "DejaVu Serif")
            "Serif"
            "Org body: no serif font found; using default."))
          (header
           (my/font-tuple
            '("Fira Sans" "Fira Sans Condensed" "Ubuntu Sans" "DejaVu Sans")
            "Sans Serif"
            "Org headers: no sans font found; using default."))
          (mono
           (my/font-tuple
            '("Fira Code" "Fira Mono" "DejaVu Sans Mono" "Ubuntu Mono")
            "Monospace"
            "Org mono: no monospace font found; using default.")))
      (list body header mono)))

  (defun my/apply-face-font (face height tuple)
    "Apply HEIGHT and font from TUPLE to FACE.
TUPLE is either (:font \"Name\") or (:family \"Family\")."
    (when tuple
      (set-face-attribute
       face nil
       :height height
       :family (or (plist-get tuple :font)
                   (plist-get tuple :family)))))

  (defun my/apply-org-fonts ()
    (pcase-let* ((`(,body-tuple ,header-tuple ,mono-tuple) (my/org-font-tuples))
                 (vp-height 110)
                 (fp-height 90)
                 (headline '(:weight semibold)))

      ;; Base faces
      (my/apply-face-font 'variable-pitch vp-height body-tuple)
      (my/apply-face-font 'fixed-pitch   fp-height mono-tuple)

      ;; Enable variable pitch automatically in Org buffers
      (add-hook 'org-mode-hook #'variable-pitch-mode)

      ;; Org faces
      (custom-theme-set-faces
       'user
       `(org-default ((t (:inherit variable-pitch))))
       `(org-document-info ((t (:inherit variable-pitch))))
       `(org-document-info-keyword ((t (:inherit fixed-pitch))))

       `(org-document-title
         ((t (,@headline
              ,@header-tuple
              :height 1.15
              :underline nil
              :weight bold))))

       `(org-level-8 ((t (,@headline ,@header-tuple :height 1.00))))
       `(org-level-7 ((t (,@headline ,@header-tuple :height 1.00))))
       `(org-level-6 ((t (,@headline ,@header-tuple :height 1.00))))
       `(org-level-5 ((t (,@headline ,@header-tuple :height 1.05))))
       `(org-level-4 ((t (,@headline ,@header-tuple :height 1.10))))
       `(org-level-3 ((t (,@headline ,@header-tuple :height 1.18))))
       `(org-level-2 ((t (,@headline ,@header-tuple :height 1.25))))
       `(org-level-1 ((t (,@headline ,@header-tuple :height 1.35))))

       `(org-block ((t (:inherit fixed-pitch))))
       `(org-block-begin-line ((t (:inherit fixed-pitch))))
       `(org-block-end-line ((t (:inherit fixed-pitch))))
       `(org-code ((t (:inherit fixed-pitch))))
       `(org-verbatim ((t (:inherit fixed-pitch))))
       `(org-table ((t (:inherit fixed-pitch))))
       `(org-meta-line ((t (:inherit fixed-pitch))))
       `(org-checkbox ((t (:inherit fixed-pitch))))
       `(org-special-keyword ((t (:inherit fixed-pitch))))
       `(org-tag ((t (:inherit fixed-pitch))))

       `(line-number ((t (:inherit fixed-pitch))))
       `(line-number-current-line ((t (:inherit fixed-pitch))))
       `(linum ((t (:inherit fixed-pitch)))))))

  ;; Apply after theme loads (and immediately once, so you don’t need a theme toggle)
  (add-hook 'after-load-theme-hook #'my/apply-org-fonts)
  (my/apply-org-fonts)


  ;; Make ellipsis render in monospace (symbol coverage)
  (set-face-attribute 'org-ellipsis nil :inherit 'fixed-pitch)

  ;; --- Org core settings ---
  (require 'cider)
  (add-to-list 'org-babel-tangle-lang-exts '("clojure" . "clj"))

  (setq org-src-window-setup 'split-window-right
        org-enable-reveal-js-support t
        org-insert-heading-respect-content t
        org-startup-indented t
        org-directory (file-truename my/org-home)
        org-agenda-files (list
                          (expand-file-name "main.org"  org-directory)
                          (expand-file-name "tasks.org" org-directory))
        org-default-notes-file (expand-file-name "main.org" org-directory)
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-scheduled-if-done t
        org-want-todo-bindings t
        org-hide-emphasis-markers t
        org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)" "CANC(c)"))
        org-startup-truncated nil
        org-startup-folded 'fold
        org-ellipsis "▼"
        org-babel-load-languages '((emacs-lisp . t)
                                   (R . t)
                                   (python . t)
                                   (clojure . t)
                                   (sql . t))
        org-babel-clojure-backend 'cider
        ob-clojure-babashka-command (executable-find "bb")
        nrepl-sync-request-timeout nil
        org-confirm-babel-evaluate nil
        org-file-apps '((auto-mode . emacs))
        org-refile-targets '((nil :maxlevel . 9)
                             (org-agenda-files :maxlevel . 9))
        org-startup-with-inline-images t
        org-agenda-custom-commands '()
        org-capture-templates
        `(("t" "Todo" entry (file+olp ,(expand-file-name "tasks.org" org-directory) "Open")
           "* TODO %?\nSCHEDULED: %t" :prepend t)
          ("n" "Next action" entry (file+olp ,(expand-file-name "tasks.org" org-directory) "Open")
           "* NEXT %?\nSCHEDULED: %t" :prepend t)
          ("w" "Waiting" entry (file+headline ,(expand-file-name "tasks.org" org-directory) "Open")
           "* WAIT %?\nSCHEDULED: %t" :prepend t)
          ("m" "Meeting" entry (file+olp ,(expand-file-name "main.org" org-directory) "Meetings")
           "* %? %u\n%t\n** Notes\n** Action items" :clock-in t :clock-resume t)
          ("M" "Meeting (plan)" entry (file+headline ,(expand-file-name "main.org" org-directory) "Meetings")
           "* %?\nSCHEDULED: %^T\nOBJECTIVE:\n** Agenda\n** Notes\n** Action items")
          ("e" "Email or message" entry (file+headline ,(expand-file-name "main.org" org-directory) "Messages")
           "* %?\nSCHEDULED: %t\n[[file:%(expand-file-name (format \"messages/%s.msg\" (format-time-string \"%Y%m%d-%H%M%S\")) org-directory)]]"
           :prepend t)
          ("p" "Paste clipboard" entry (file+headline ,(expand-file-name "main.org" org-directory) "UNFILED")
           "* %?\n\n%x")
          ("i" "Idea" entry (file+headline ,(expand-file-name "main.org" org-directory) "Ideas")
           "* %?\n%t")))

  ;; org-reveal
  (require 'ox-reveal)
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")

  (add-to-list 'org-agenda-custom-commands
               '("g" "GTD View"
                 tags "+SCHEDULED<=\"<+0d>\""
                 ((org-agenda-overriding-columns-format
                   "%40ITEM %TODO %3PRIORITY %SCHEDULED %DEADLINE %TAGS")
                  (org-agenda-skip-function
                   '(org-agenda-skip-entry-if 'nottodo 'todo))
                  (org-agenda-sorting-strategy '(priority-down scheduled-down))
                  (org-agenda-view-columns-initially t))))

  (add-to-list 'org-agenda-custom-commands
               '("d" "Deadline in next month"
                 tags "+DEADLINE<=\"<+2m>\""
                 ((org-agenda-overriding-columns-format
                   "%40ITEM %TODO %3PRIORITY %SCHEDULED %DEADLINE %TAGS")
                  (org-agenda-skip-function
                   '(or (org-agenda-skip-entry-if 'todo '("DONE" "CANC"))
                        (org-agenda-skip-entry-if 'notdeadline)))
                  (org-agenda-sorting-strategy '(deadline-up))
                  (org-agenda-view-columns-initially t))))

  ;; duckdb org-babel
  (add-to-list 'org-babel-load-languages '(duckdb . t))
  (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)
  (add-to-list 'org-src-lang-modes '("duckdb" . sql)))

;; tangle-on-save (local to org buffers)
(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'org-babel-tangle :append :local)))

(with-eval-after-load 'cider
  ;; Just the project name in REPL buffer like *clj:my-project*
  (setq cider-session-name-template "clj:%p"))

(gptel-make-anthropic "Claude"
  :stream t
  :key (lambda () (getenv "ANTHROPIC_API_KEY")))

(gptel-make-gemini "Gemini"
  :stream t
  :key (lambda () (getenv "GEMINI_API_KEY")))

(with-eval-after-load 'ob-python
  (setq org-babel-python-command "python3"))

(add-to-list 'load-path "~/.emacs.d/private/beancount-mode")
(require 'beancount)
(add-to-list 'auto-mode-alist '("\\.beancount\\'" . beancount-mode))
