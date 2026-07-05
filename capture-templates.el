;; org-capture-templates and org-roam-capture-templates.
;; Loaded by user-config.el inside (with-eval-after-load 'org ...) after
;; org-directory is set, so expand-file-name references work correctly.

(setq org-capture-templates

      ;; -- TODO | NEXT | WAIT --
      ;; Places in tasks.org::Open
      ;; Schedules for the current day
      `(("t" "Todo" entry (file+olp ,(expand-file-name "tasks.org" org-directory) "Open")
         "* TODO %?\nSCHEDULED: %t" :prepend t)
        ("n" "Next action" entry (file+olp ,(expand-file-name "tasks.org" org-directory) "Open")
         "* NEXT %?\nSCHEDULED: %t" :prepend t)
        ("w" "Waiting" entry (file+headline ,(expand-file-name "tasks.org" org-directory) "Open")
         "* WAIT %?\nSCHEDULED: %t" :prepend t)

        ;; -- Other randoms --
        ("e" "Email or message" entry (file+headline ,(expand-file-name "cohere.org" org-directory) "Messages")
         "* %?\nSCHEDULED: %t\n[[file:%(expand-file-name (format \"messages/%s.msg\" (format-time-string \"%Y%m%d-%H%M%S\")) org-directory)]]"
         :prepend t)
        ("p" "Paste clipboard" entry (file+headline ,(expand-file-name "cohere.org" org-directory) "UNFILED")
         "* %?\n\n%x")
        ("i" "Idea" entry (file+headline ,(expand-file-name "cohere.org" org-directory) "Ideas")
         "* %?\n%t")
        ("l" "Log" entry (file+datetree ,(expand-file-name "log.org" org-directory))
         "* %^{Title}\n:PROPERTIES:\n:ID: %(org-id-new)\n:END:\n%?"
         :clock-in t :clock-resume t)))

(setq org-roam-capture-templates

      '(
        ("d" "Default" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+options: toc:nil num:nil")
         :immediate-finish t
         :unnarrowed t)

        ("p" "Person" plain
         "* Notes\n%?\n* Experience\n\n* Education"
         :target (file+head "people/${slug}.org"
                            ":PROPERTIES:\n:company: %^{Company|Cohere}\n:role: %^{Role}\n:location: %^{Location}\n:timezone: %^{Timezone|America/Toronto|America/New_York|America/Los_Angeles|Europe/London|UTC}\n:ID:       %(org-id-new)\n:END:\n#+title: ${title}\n#+filetags: :person:\n#+options: toc:nil num:nil\n\n")
         :immediate-finish t
         :unnarrowed t)

        ("m" "Meeting" plain
         "* Meta :meeting:\n:LOGBOOK:\n:END:\n%?\n\n* Attendees\n- [[id:B3A450BA-7416-49E6-BD2C-E803F31787BE][Aaron Cooley]]\n\n* Context\n\n* Notes\n\n* Takeaways\n\n* Action Items\n\n* Transcript"
         :target (file+head
                  "meetings/%<%Y%m%d%H%M%S>-${slug}.org"
                  ":PROPERTIES:\n:ID:       %(org-id-new)\n:END:\n#+title: ${title} [%<%Y-%m-%d %a>]\n#+filetags: :meeting:\n#+date: %U\n#+options: toc:nil num:nil\n\n")
         :clock-in t
         :clock-resume t
         :immediate-finish t
         :unnarrowed t)

        ("i" "Initiative" plain
         "* Objective\n%?\n\n* Key Results\n- [ ] \n\n* Notes\n\n* Log"
         :target (file+head "initiatives/${slug}.org"
                            ":PROPERTIES:\n:ID:       %(org-id-new)\n:PILLAR: %^{Pillar|NI|DF|BI}\n:STATUS: %^{Status|active|planned|paused}\n:OWNER:    [[id:B3A450BA-7416-49E6-BD2C-E803F31787BE][Aaron Cooley]]\n:START: %U\n:TARGET: \n:END:\n#+title: ${title}\n#+filetags: :initiative:%\\1:\n#+options: toc:nil num:nil\n\n")
         :immediate-finish t
         :unnarrowed t)

        ("s" "Message" plain
         "* Meta :message:\n:PROPERTIES:\n:PLATFORM: %^{Platform|Slack|Email|Google Chat|Teams}\n:CHANNEL: %^{Channel/From}\n:DATE: %^{Date}u\n:URL: %^{URL}\n:END:\n\n* Participants\n- [[id:B3A450BA-7416-49E6-BD2C-E803F31787BE][Aaron Cooley]]\n\n* Content\n%?\n\n* Key Points\n\n* Action Items"
         :target (file+head "messages/%<%Y%m%d%H%M%S>-${slug}.org"
                            ":PROPERTIES:\n:ID:       %(org-id-new)\n:END:\n#+title: ${title}\n#+filetags: :message:\n#+date: %U\n#+options: toc:nil num:nil\n\n")
         :immediate-finish t
         :unnarrowed t)
        ))

;; org-roam DAILIES capture templates.
;; Single template keyed "d" so org-roam-dailies-goto-today / -capture-today
;; never prompts for a selection. Lays down the full /plan-day skeleton on a
;; new daily; jumps straight to the file if it already exists. :immediate-finish
;; saves+closes without an interactive capture buffer; :unnarrowed lands you in
;; the whole file.
(setq org-roam-dailies-capture-templates

      '(("d" "Daily" plain ""
         :target (file+head
                  "%<%Y-%m-%d>.org"
                  ":PROPERTIES:\n:ID:       %(org-id-new)\n:END:\n#+title: %<%Y-%m-%d>\n#+filetags: :daily:\n#+OPTIONS: num:nil\n\n* Log\n|  Time | Task | Type |\n|-------+------+------|\n|       |      |      |\nKey:\n- =A= Administrative\n- =B= Break/personal\n- =D= Deep work\n- =I= Initiative work\n- =M= Meeting\n\n* Schedule\n\n* High Priority Tasks\n\n* Blockers & Urgent\n\n* Initiative Status\n\n* Decision Points\n\n* Yesterday Carry-Over\n\n* Tomorrow Preview\n\n* Captures\n")
         :immediate-finish t
         :unnarrowed t)))
