;;; packages.el --- agent-shell layer packages  -*- lexical-binding: t; -*-

(defconst agent-shell-packages
  '(
    (agent-shell :location "~/source/agent-shell")
    shell-maker
    acp))

(defun agent-shell/init-shell-maker ()
  "shell-maker is a dependency of agent-shell — no own config needed."
  (use-package shell-maker))

(defun agent-shell/init-acp ()
  "acp (Agent Client Protocol) is a dependency of agent-shell — no own config needed."
  (use-package acp))

(defun agent-shell/init-agent-shell ()
  "Initialize agent-shell package and bind SPC $ a keymap.

`SPC $' is the established Spacemacs 'AI' prefix (used by
github-copilot, llm-client, openai, whisper layers). agent-shell
takes the `a' sub-prefix."
  (use-package agent-shell
    :config
    (setq agent-shell-preferred-agent-config
          (agent-shell-opencode-make-agent-config))

    (spacemacs/declare-prefix "$ a" "agent-shell")

    (spacemacs/set-leader-keys
      "$ a n" #'agent-shell-new-shell
      "$ a a" #'agent-shell
      "$ a o" #'agent-shell-other-buffer
      "$ a r" #'agent-shell-resume-session
      "$ a s" #'agent-shell-viewport-search-history
      "$ a f" #'agent-shell-fork
      "$ a i" #'agent-shell-interrupt
      "$ a t" #'agent-shell-toggle
      "$ a l" #'agent-shell-view-acp-logs
      "$ a R" #'agent-shell-restart
      "$ a b" #'agent-shell-switch-buffer
      "$ a v" #'agent-shell-view-traffic
      "$ a T" #'agent-shell-open-transcript
      "$ a c" #'agent-shell-copy-session-id
      "$ a m" #'agent-shell-copy-as-markdown
      "$ a p" #'agent-shell-prompt-compose
      "$ a w" #'agent-shell-new-worktree-shell
      "$ a g" #'agent-shell-goto-last-interaction
      "$ a L" #'agent-shell-toggle-logging
      "$ a V" #'agent-shell-version)

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
      "SPC $ a R" "restart"
      "SPC $ a b" "switch-buffer"
      "SPC $ a v" "view-traffic"
      "SPC $ a T" "transcript"
      "SPC $ a c" "copy-session-id"
      "SPC $ a m" "copy-markdown"
      "SPC $ a p" "prompt-compose"
      "SPC $ a w" "worktree-shell"
      "SPC $ a g" "goto-last-interaction"
      "SPC $ a L" "toggle-logging"
      "SPC $ a V" "version")

    (spacemacs/set-leader-keys-for-major-mode 'agent-shell-mode
      "m"   #'agent-shell-cycle-session-mode
      "M"   #'agent-shell-set-session-model
      "o"   #'agent-shell-set-session-mode
      "t"   #'agent-shell-set-session-thought-level
      "s"   #'agent-shell-set-session-config-option
      "?"   #'agent-shell-help-menu
      "k"   #'agent-shell-clear-buffer
      "C-c" #'agent-shell-interrupt)

    (which-key-add-major-mode-key-based-replacements 'agent-shell-mode
      "m"   "cycle-mode"
      "M"   "set-model"
      "o"   "set-mode"
      "t"   "set-thought"
      "s"   "set-option"
      "?"   "help-menu"
      "k"   "clear-buffer"
      "C-c" "interrupt")))

;;; packages.el ends here
