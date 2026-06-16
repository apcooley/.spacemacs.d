(add-to-list 'auto-mode-alist
             '("\\.html?\\'" . (lambda ()
                                 (browse-url-of-file (buffer-file-name))
                                 (kill-buffer))))

(use-package ligature
  :ensure t
  :config
  (ligature-set-ligatures
   't
   ;; Trimmed to ligatures FiraCode-Regular.ttf actually ships.
   ;; Confirmed via fontTools GSUB inspection (2026-06-16):
   ;; "{-", "-}", "[]", "\\\\", "\\\\\\" are NOT present in stock
   ;; Fira Code and have been removed.
   ;; "/\\", "\\/", "{|", "[|", "|}", "|]" ARE present and added.
   '("www" "**" "***" "**/" "*>" "*/"
     "::" ":::" ":=" "!!" "!=" "!=="
     "--" "---" "-->" "->" "->>" "-<" "-<<" "-~"
     "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
     ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*"
     "/**" "/=" "/==" "/>" "//" "///" "/\\" "\\/"
     "&&" "||" "||=" "|=" "|>" "|}" "|]"
     "{|" "[|"
     "^=" "$>" "++" "+++" "+>" "=:=" "=="
     "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">="
     ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>"
     "<$" "<$>" "<!--" "<-" "<--" "<->" "<+" "<+>" "<="
     "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<" "<~"
     "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))
  (global-ligature-mode t))

(use-package pet
  :config
  (add-hook 'python-base-mode-hook 'pet-mode -10))

;; faster project indexing
(setq projectile-indexing-method 'alien)

;; Reasonable startup frame size instead of spanning all monitors
(setq default-frame-alist
      (append '((width . 100)
                (height . 35))
              default-frame-alist))

;; custom packages not from ELPA/MELPA
(add-to-list 'load-path "~/.spacemacs.d/elisp/ob-duckdb/")
(require 'ob-duckdb)

(add-to-list 'load-path "~/.spacemacs.d/elisp/ob-bigquery/")
(require 'ob-bigquery)

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

(use-package markdown-preview-mode
  :ensure t
  :after markdown-mode
  :commands (markdown-preview-mode markdown-preview-open-browser)
  :config
  ;; GitHub-flavored CSS for fidelity
  (setq markdown-preview-stylesheets
        (list "https://cdn.jsdelivr.net/npm/github-markdown-css/github-markdown.min.css"
              "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/styles/github.min.css"))
  (setq markdown-preview-javascript
        (list "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/highlight.min.js"
              "<script>document.addEventListener('DOMContentLoaded', () => { document.body.classList.add('markdown-body'); hljs.highlightAll(); });</script>")))

;; Override the Spacemacs default (which calls broken vmd) with markdown-preview-mode
(with-eval-after-load 'markdown-mode
  (spacemacs/set-leader-keys-for-major-mode 'markdown-mode
    "c P" #'markdown-preview-mode)
  (spacemacs/set-leader-keys-for-major-mode 'gfm-mode
    "c P" #'markdown-preview-mode))

;; For use with org-reveal
(with-eval-after-load 'sgml-mode
  (require 'emmet-mode)
  (add-hook 'sgml-mode-hook #'emmet-mode)
  (add-hook 'css-mode-hook #'emmet-mode))

;; Custom keybindings
(spacemacs/set-leader-keys
  "f R" 'recover-this-file
  "f n" 'spacemacs/rename-current-buffer-file
  "i e" 'emoji-search)

(spacemacs-bootstrap/init-which-key)

(which-key-add-key-based-replacements
  "SPC f n" "Rename"
  "SPC f R" "Recover"
  "SPC i e" "Emoji")

(spacemacs/set-leader-keys-for-major-mode 'clojure-mode
  "s s" 'cider-switch-to-repl-buffer)

(spacemacs/set-leader-keys-for-major-mode 'org-mode
  "g" 'org-todo
  "r I" 'org-id-get-create
  "r s" 'org-roam-db-sync
  "| |" 'org-columns
  "| q" #'org-columns-quit
  "| r" #'org-columns-redo
  "| e" #'org-columns-edit-value
  "| a" #'org-columns-edit-allowed
  "| n" #'org-columns-next-allowed-value
  "| p" #'org-columns-previous-allowed-value
  "| N" #'org-columns-new
  "| d" #'org-columns-delete
  "| h" #'org-columns-move-left
  "| l" #'org-columns-move-right
  "| >" #'org-columns-widen
  "| <" #'org-columns-narrow
  "| i" #'org-columns-insert-dblock)

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
(defconst my/org-home "~/org/my-org/"
  "Root directory for Org files on this machine.")

(unless (file-directory-p my/org-home)
  (warn "Org home does not exist: %s" my/org-home))

;; All Org-specific config must wait until Org is loaded (Spacemacs lazy-load).
(with-eval-after-load 'org

  ;; --- Org-roam multiple headings per file ---
  (setq org-roam-db-node-include-function
        (lambda () (org-entry-get nil "ID")))

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
  (add-to-list 'org-structure-template-alist '("bash" . "src bash"))

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
                 (vp-height 1.15)
                 (fp-height 0.95)
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

       `(line-number ((t (:inherit fixed-pitch :height 1.0))))
       `(line-number-current-line ((t (:inherit fixed-pitch :height 1.0))))
       `(linum ((t (:inherit fixed-pitch :height 1.0)))))))

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
        org-default-notes-file (expand-file-name "tasks.org" org-directory)
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
                                   (sql . t)
                                   (shell . t))
        org-babel-clojure-backend 'cider
        ob-clojure-babashka-command (executable-find "bb")
        nrepl-sync-request-timeout nil
        org-confirm-babel-evaluate nil
        org-file-apps '((auto-mode . emacs))
        org-refile-targets '((nil :maxlevel . 9)
                             (org-agenda-files :maxlevel . 9))
        org-startup-with-inline-images t
        org-agenda-custom-commands '()

        org-roam-directory (expand-file-name "roam/" org-directory)
        org-roam-completion-everywhere t
        org-roam-db-gc-threshold most-positive-fixnum
        org-roam-node-display-template (concat "${title:*} " (propertize "${tags:20}" 'face 'org-tag)))

  ;; Load capture templates from dedicated file (org-directory is set above)
  (load-file (expand-file-name "~/.spacemacs.d/capture-templates.el"))

  ;; org-reveal
  (require 'ox-reveal)
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")

  ;; Custom agenda views
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
  (add-to-list 'org-src-lang-modes '("duckdb" . sql))

  ;; bigquery org-babel
  (add-to-list 'org-babel-load-languages '(bigquery . t))
  (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)
  (add-to-list 'org-src-lang-modes '("bigquery" . sql)))

;; tangle-on-save (local to org buffers)
(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'org-babel-tangle :append :local)))

;; org-roam functions
(org-roam-db-autosync-mode)
(defun my/org-roam-agenda-files ()
  (seq-uniq
   (append
    (mapcar #'car (org-roam-db-query
                   [:select [nodes:file] :from tags
                            :left-join nodes :on (= tags:node-id nodes:id)
                            :where (= tags:tag "meeting")]))
    (mapcar #'car (org-roam-db-query
                   [:select [nodes:file] :from tags
                            :left-join nodes :on (= tags:node-id nodes:id)
                            :where (= tags:tag "project")])))))

(defun my/org-agenda-files-refresh ()
  (interactive)
  (setq org-agenda-files
        (append
         (list (expand-file-name "tasks.org" org-directory))
         (my/org-roam-agenda-files))))

(my/org-agenda-files-refresh)
(add-hook 'org-roam-find-file-hook #'my/org-agenda-files-refresh)

(use-package org-live
  :load-path "~/source/org-live"
  :commands (org-live-preview-mode
             org-live-keystroke-preview
             org-live-cycle-theme))

(use-package cohere-css
  :load-path "~/source/cohere-css"
  :after org-live)

(with-eval-after-load 'org
  (spacemacs/declare-prefix-for-mode 'org-mode "mP" "preview-html")
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
    "P p" #'org-live-preview-mode
    "P l" #'org-live-keystroke-preview
    "P t" #'org-live-cycle-theme))

(add-to-list 'load-path (expand-file-name "~/org/my-org/cos"))
(require 'aaron-cos-commands)

(use-package agent-shell
  :ensure t
  :config
  (setq agent-shell-preferred-agent-config
        (agent-shell-opencode-make-agent-config)))

;; SPC $ a — agent-shell submenu
(spacemacs/declare-prefix "$ a" "agent-shell")
(spacemacs/set-leader-keys
  "$ a n" #'agent-shell-new-shell        ; new session
  "$ a a" #'agent-shell                  ; open/resume current
  "$ a o" #'agent-shell-other-buffer     ; switch to other agent buffer
  "$ a r" #'agent-shell-resume-session   ; resume a past session
  "$ a s" #'agent-shell-search-history   ; search session history
  "$ a f" #'agent-shell-fork             ; fork current session
  "$ a i" #'agent-shell-interrupt        ; interrupt running agent
  "$ a t" #'agent-shell-toggle           ; toggle visibility
  "$ a l" #'agent-shell-view-acp-logs    ; view ACP logs
  "$ a R" #'agent-shell-restart)         ; restart agent

(which-key-add-key-based-replacements
  "SPC $ a"   "agent-shell"
  "SPC $ a n" "new-shell"
  "SPC $ a a" "open/resume"
  "SPC $ a o" "other-buffer"
  "SPC $ a r" "resume-session"
  "SPC $ a s" "search-history"
  "SPC $ a f" "fork"
  "SPC $ a i" "interrupt"
  "SPC $ a t" "toggle"
  "SPC $ a l" "view-logs"
  "SPC $ a R" "restart")

(with-eval-after-load 'cider
  ;; Just the project name in REPL buffer like *clj:my-project*
  (setq cider-session-name-template "clj:%p"))

(gptel-make-anthropic "Claude"
  :stream t
  :key (lambda () (getenv "ANTHROPIC_API_KEY")))

(gptel-make-gemini "Gemini"
  :stream t
  :key (lambda () (getenv "GEMINI_API_KEY")))

(use-package gptel-agent
  :vc ( :url "https://github.com/karthink/gptel-agent"
        :rev :newest)
  :config (gptel-agent-update))

(with-eval-after-load 'ob-python
  (setq org-babel-python-command "python3"))

(add-to-list 'load-path "~/.emacs.d/private/beancount-mode")
(require 'beancount)
(add-to-list 'auto-mode-alist '("\\.beancount\\'" . beancount-mode))
