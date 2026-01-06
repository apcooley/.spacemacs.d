;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. "~/.mycontribs/")
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(toml
     yaml
     csv
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press `SPC f e R' (Vim style) or
     ;; `M-m f e R' (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     (auto-completion :variables
                      auto-completion-return-key-behavior nil
                      auto-completion-tab-key-behavior 'complete
                      auto-completion-enable-snippets-in-popup t)
     better-defaults
     (clojure :variables
              clojure-backend 'cider)
     emacs-lisp
     (ess :variables
          ess-ask-for-ess-directory nil
          ess-r-backend 'lsp
          ess-eval-visibly 'nowait)
     git
     html
     (ivy :variables
          ivy-enable-advanced-buffer-information t)
     (javascript :variables js-indent-level 1)
     lsp
     lua
     markdown
     ;; multiple-cursors
     org
     pandoc
     (python :variables
             python-backend 'lsp
             python-lsp-server 'pyright
             python-formatter 'black
             python-enable-tools '(uv))
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom)
     (spacemacs-layouts :variables
                        spacemacs-layouts-restrict-spc-tab t)
     ;; spell-checking
     sql
     syntax-checking
     (tree-sitter :variables
                  tree-sitter-syntax-highlight-enable t
                  tree-sitter-fold-enable t
                  tree-sitter-fold-indicators-enable nil)
     version-control
     treemacs
     windows-scripts
     (xclipboard :variables xclipboard-enable-cliphist t)
     )


   ;; List of additional packages that will be installed without being wrapped
   ;; in a layer (generally the packages are installed only and should still be
   ;; loaded using load/require/use-package in the user-config section below in
   ;; this file). If you need some configuration for these packages, then
   ;; consider creating a layer. You can also put the configuration in
   ;; `dotspacemacs/user-config'. To use a local version of a package, use the
   ;; `:location' property: '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '(emmet-mode ox-reveal vega-view org-superstar)

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(vim-powerline code-review)

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. Spacelpa is currently in
   ;; experimental state please use only for testing purposes.
   ;; (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style '(hybrid :variables
                                       hybrid-style-visual-feedback nil
                                       hybrid-style-enable-evilified-state t
                                       hybrid-style-enable-hjkl-bindings nil
                                       hybrid-style-use-evil-search-module nil
                                       hybrid-style-default-state 'normal)

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version t

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; Scale factor controls the scaling (size) of the startup banner. Default
   ;; value is `auto' for scaling the logo automatically to fit all buffer
   ;; contents, to a maximum of the full image height and a minimum of 3 line
   ;; heights. If set to a number (int or float) it is used as a constant
   ;; scaling factor for the default logo size.
   dotspacemacs-startup-banner-scale 'auto

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `recents-by-project' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   ;; The exceptional case is `recents-by-project', where list-type must be a
   ;; pair of numbers, e.g. `(recents-by-project . (7 .  5))', where the first
   ;; number is the project limit and the second the limit on the recent files
   ;; within a project.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Show numbers before the startup list lines. (default t)
   dotspacemacs-show-startup-list-numbers t

   ;; The minimum delay in seconds between number key presses. (default 0.4)
   dotspacemacs-startup-buffer-multi-digit-delay 0.4

   ;; If non-nil, show file icons for entries and headings on Spacemacs home buffer.
   ;; This has no effect in terminal or if "nerd-icons" package or the font
   ;; is not installed. (default nil)
   dotspacemacs-startup-buffer-show-icons nil

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; If non-nil, *scratch* buffer will be persistent. Things you write down in
   ;; *scratch* buffer will be saved and restored automatically.
   dotspacemacs-scratch-buffer-persistent nil

   ;; If non-nil, `kill-buffer' on *scratch* buffer
   ;; will bury it instead of killing.
   dotspacemacs-scratch-buffer-unkillable nil

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light). A theme from external
   ;; package can be defined with `:package', or a theme can be defined with
   ;; `:location' to download the theme package, refer the themes section in
   ;; DOCUMENTATION.org for the full theme specifications.
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts. This setting has no effect when
   ;; running Emacs in terminal. The font set here will be used for default and
   ;; fixed-pitch faces. The `:size' can be specified as
   ;; a non-negative integer (pixel size), or a floating-point (point size).
   ;; Point size is recommended, because it's device independent. (default 10.0)
   dotspacemacs-default-font '("Fira Code"
                               :size 20.0
                               :weight normal
                               :width normal)

   ;; Default icons font, it can be `all-the-icons' or `nerd-icons'.
   dotspacemacs-default-icons-font 'all-the-icons

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "M-<return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key (if window-system "M-<return>" "C-M-m")

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; It is also possible to use a posframe with the following cons cell
   ;; `(posframe . position)' where position can be one of `center',
   ;; `top-center', `bottom-center', `top-left-corner', `top-right-corner',
   ;; `top-right-corner', `bottom-left-corner' or `bottom-right-corner'
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; Make consecutive tab key presses after commands such as
   ;; `spacemacs/alternate-buffer' (SPC TAB) cycle through previous
   ;; buffers/windows/etc. Please see the option's docstring for more information.
   ;; Set the option to t in order to enable cycling for all current and
   ;; future cycling commands. Alternatively, choose a subset of the currently
   ;; supported commands: '(alternate-buffer alternate-window). (default nil)
   dotspacemacs-enable-cycling nil

   ;; Whether side windows (such as those created by treemacs or neotree)
   ;; are kept or minimized by `spacemacs/toggle-maximize-window' (SPC w m).
   ;; (default t)
   dotspacemacs-maximize-window-keep-side-windows t

   ;; If nil, no load-hints enabled. If t, enable the `load-hints' which will
   ;; put the most likely path on the top of `load-path' to reduce walking
   ;; through the whole `load-path'. It's an experimental feature to speedup
   ;; Spacemacs on Windows. Refer the FAQ.org "load-hints" session for details.
   dotspacemacs-enable-load-hints nil

   ;; If t, enable the `package-quickstart' feature to avoid full package
   ;; loading, otherwise no `package-quickstart' attemption (default nil).
   ;; Refer the FAQ.org "package-quickstart" section for details.
   dotspacemacs-enable-package-quickstart nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default t) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup t

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' to obtain fullscreen
   ;; without external boxes. Also disables the internal border. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes the
   ;; transparency level of a frame background when it's active or selected. Transparency
   ;; can be toggled through `toggle-background-transparency'. (default 90)
   dotspacemacs-background-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Show the scroll bar while scrolling. The auto hide time can be configured
   ;; by setting this variable to a number. (default t)
   dotspacemacs-scroll-bar-while-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but only visual lines are counted. For example, folded lines will not be
   ;; counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers 'visual

   ;; Code folding method. Possible values are `evil', `origami' and `vimish'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil and `dotspacemacs-activate-smartparens-mode' is also non-nil,
   ;; `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil smartparens-mode will be enabled in programming modes.
   ;; (default t)
   dotspacemacs-activate-smartparens-mode t

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `ack' and `grep'.
   ;; (default '("rg" "ag" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "ack" "grep")

   ;; The backend used for undo/redo functionality. Possible values are
   ;; `undo-redo', `undo-fu' and `undo-tree' see also `evil-undo-system'.
   ;; Note that saved undo history does not get transferred when changing
   ;; your undo system from or to undo-tree. (default `undo-redo')
   dotspacemacs-undo-system 'undo-redo

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; If nil then Spacemacs uses default `frame-title-format' to avoid
   ;; performance issues, instead of calculating the frame title by
   ;; `spacemacs/title-prepare' all the time.
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Color highlight trailing whitespace in all prog-mode and text-mode derived
   ;; modes such as c++-mode, python-mode, emacs-lisp, html-mode, rst-mode etc.
   ;; (default t)
   dotspacemacs-show-trailing-whitespace t

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; The variable `global-spacemacs-whitespace-cleanup-modes' controls
   ;; which major modes have whitespace cleanup enabled or disabled
   ;; by default.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; If non-nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfere with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; Accept SPC as y for prompts if non-nil. (default nil)
   dotspacemacs-use-SPC-as-y nil

   ;; If non-nil shift your number row to match the entered keyboard layout
   ;; (only in insert state). Currently supported keyboard layouts are:
   ;; `qwerty-us', `qwertz-de' and `querty-ca-fr'.
   ;; New layouts can be added in `spacemacs-editing' layer.
   ;; (default nil)
   dotspacemacs-swap-number-row nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil

   ;; If nil the home buffer shows the full path of agenda items
   ;; and todos. If non-nil only the file name is shown.
   dotspacemacs-home-shorten-agenda-source nil

   ;; If non-nil then byte-compile some of Spacemacs files.
   dotspacemacs-byte-compile nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env)
  )

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  ;; find-file in home directory
  (setq default-directory (expand-file-name "~/"))
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
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
    (add-hook 'sgml-mode-hook 'emmet-mode) ;; For HTML
    (add-hook 'css-mode-hook 'emmet-mode)) ;; For CSS
  (with-eval-after-load 'sql
    ;; Ensure that only a line that starts with GO (optionally with trailing whitespace)
    ;; is treated as a batch terminator.
    (setq sql-comint-go-regexp "^GO[ \t]*$")
    ;; Your existing settings for sqlcmd:
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
    "SPC f n" "Rename")
  (which-key-add-key-based-replacements
    "SPC f R" "Recover")
  (spacemacs/set-leader-keys-for-major-mode 'clojure-mode
    "s s" 'cider-switch-to-repl-buffer)
  (with-eval-after-load 'paredit
    ;; Disable the default RET keybinding in paredit-mode
    (define-key paredit-mode-map (kbd "RET") nil)
    ;; Rebind RET in cider-repl-mode to support new lines without sending code
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

  ;; === Org-mode ===
  (with-eval-after-load 'org

    ;; Replace list item markers like "-" with a bullet, and optionally prettify headlines.
    (use-package org-superstar
      :ensure t
      :after org
      :hook (org-mode . org-superstar-mode)
      :config
      ;; List bullets: treat -, +, * as the same nice bullet.
      (setq org-superstar-item-bullet-alist '((?- . ?•) (?+ . ?•) (?* . ?•)))

      ;; Keep indentation behavior sane (Spacemacs often enables org-indent)
      (setq org-superstar-remove-leading-stars t)

      ;; If you want headline stars to stay as stars (no fancy glyphs), keep these nil:
      ;; (setq org-superstar-headline-bullets-list nil)
      )

    ;; Choose fonts with fallback logic (portable across machines)
    (let* ((body-tuple
            (cond ((x-list-fonts "Crimson")         '(:font "Crimson"))
                  ((x-list-fonts "Crimson Text")    '(:font "Crimson Text"))
                  ((x-list-fonts "DejaVu Serif")    '(:font "DejaVu Serif"))
                  ((x-family-fonts "Serif")         '(:family "Serif"))
                  (t (warn "Org body: no serif font found; using default.") nil)))
           (header-tuple
            (cond ((x-list-fonts "Fira Sans")            '(:font "Fira Sans"))
                  ((x-list-fonts "Fira Sans Condensed") '(:font "Fira Sans Condensed"))
                  ((x-list-fonts "Ubuntu Sans")         '(:font "Ubuntu Sans"))
                  ((x-list-fonts "DejaVu Sans")         '(:font "DejaVu Sans"))
                  ((x-family-fonts "Sans Serif")        '(:family "Sans Serif"))
                  (t (warn "Org headers: no sans font found; using default.") nil)))
           (mono-tuple
            (cond ((x-list-fonts "Fira Code")        '(:font "Fira Code"))
                  ((x-list-fonts "Fira Mono")        '(:font "Fira Mono"))
                  ((x-list-fonts "DejaVu Sans Mono") '(:font "DejaVu Sans Mono"))
                  ((x-list-fonts "Ubuntu Mono")      '(:font "Ubuntu Mono"))
                  ((x-family-fonts "Monospace")      '(:family "Monospace"))
                  (t (warn "Org mono: no monospace font found; using default.") nil)))

           ;; Sizes: these are the two knobs you’ll tweak most.
           (vp-height 240)   ;; body prose (Crimson)
           (fp-height 200)   ;; code/tables (Fira Code)
           (headline `(:weight semibold)))

      ;; variable-pitch / fixed-pitch base faces
      (when body-tuple
        (apply #'set-face-attribute 'variable-pitch nil
               :height vp-height
               (if (plist-get body-tuple :font)
                   (list :family (plist-get body-tuple :font))
                 (list :family (plist-get body-tuple :family)))))

      (when mono-tuple
        (apply #'set-face-attribute 'fixed-pitch nil
               :height fp-height
               (if (plist-get mono-tuple :font)
                   (list :family (plist-get mono-tuple :font))
                 (list :family (plist-get mono-tuple :family)))))

      ;; Enable variable pitch automatically in Org buffers
      (add-hook 'org-mode-hook #'variable-pitch-mode)

      ;; Org faces
      (custom-theme-set-faces
       'user

       ;; Body (prose)
       `(org-default ((t (:inherit variable-pitch))))
       `(org-document-info ((t (:inherit variable-pitch))))
       `(org-document-info-keyword ((t (:inherit fixed-pitch))))

       ;; Title
       `(org-document-title ((t (,@headline ,@header-tuple :height 1.15 :underline nil :weight bold))))

       ;; Headings
       `(org-level-8 ((t (,@headline ,@header-tuple :height 1.00))))
       `(org-level-7 ((t (,@headline ,@header-tuple :height 1.00))))
       `(org-level-6 ((t (,@headline ,@header-tuple :height 1.00))))
       `(org-level-5 ((t (,@headline ,@header-tuple :height 1.05))))
       `(org-level-4 ((t (,@headline ,@header-tuple :height 1.10))))
       `(org-level-3 ((t (,@headline ,@header-tuple :height 1.18))))
       `(org-level-2 ((t (,@headline ,@header-tuple :height 1.25))))
       `(org-level-1 ((t (,@headline ,@header-tuple :height 1.35))))

       ;; Monospace elements
       `(org-block ((t (:inherit fixed-pitch))))
       `(org-code ((t (:inherit fixed-pitch))))
       `(org-verbatim ((t (:inherit fixed-pitch))))
       `(org-table ((t (:inherit fixed-pitch))))
       `(org-meta-line ((t (:inherit fixed-pitch))))
       `(org-checkbox ((t (:inherit fixed-pitch))))
       `(org-special-keyword ((t (:inherit fixed-pitch))))
       `(org-tag ((t (:inherit fixed-pitch))))

       ;; Line numbers: keep monospace even with variable-pitch-mode
       `(line-number ((t (:inherit fixed-pitch))))
       `(line-number-current-line ((t (:inherit fixed-pitch))))
       `(linum ((t (:inherit fixed-pitch))))))

    ;; tangle-on-save
    (add-hook 'org-mode-hook
              (lambda () (add-hook 'after-save-hook #'org-babel-tangle
                                   :append :local)))

    ;; code snippets
    (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
    (add-to-list 'org-structure-template-alist '("r" . "src R"))
    (add-to-list 'org-structure-template-alist '("clj" . "src clojure"))
    (add-to-list 'org-structure-template-alist '("sql" . "src sql"))

    ;; Moved org :variables here
    (require 'cider)
    (add-to-list 'org-babel-tangle-lang-exts '("clojure" . "clj"))
    (setq org-src-window-setup 'split-window-right
          org-enable-reveal-js-support t
          org-insert-heading-respect-content t
          org-startup-indented t
          org-directory (file-truename (expand-file-name "/mnt/c/users/aaron/OneDrive/org/"))
          org-agenda-files (list (expand-file-name "main.org" org-directory))
          org-default-notes-file (expand-file-name "main.org" org-directory)
          org-capture-templates
          `(("t" "Todo" entry (file+olp ,(expand-file-name "main.org" org-directory) "Tasks" "Backlog")
             "* TODO %?\nSCHEDULED: %t" :prepend t)
            ("n" "Next action" entry (file+olp ,(expand-file-name "main.org" org-directory) "Tasks" "Backlog")
             "* NEXT %?\nSCHEDULED: %t" :prepend t)
            ("w" "Waiting" entry (file+headline ,(expand-file-name "main.org" org-directory) "Tasks" "Backlog")
             "* WAIT %?\nSCHEDULED: %t" :prepend t)
            ("m" "Meeting" entry (file+olp ,(expand-file-name "main.org" org-directory) "Meetings")
             "* %? %u\n%t\n** Notes\n** Action items" :clock-in t :clock-resume t)
            ("M" "Meeting (plan)" entry (file+headline ,(expand-file-name "main.org" org-directory) "Meetings")
             "* %? \nSCHEDULED: %^T\nOBJECTIVE: \n** Agenda\n** Notes\n** Action items")
            ("e" "Email or message" entry (file+headline ,(expand-file-name "main.org" org-directory) "Messages")
             "* %?\nSCHEDULED: %t\n[[file:%(expand-file-name (format \"messages/%s.msg\" (format-time-string \"%Y%m%d-%H%M%S\")) org-directory)]]"
             :prepend t)
            ("p" "Paste clipboard" entry (file+headline ,(expand-file-name "main.org" org-directory) "UNFILED")
             "* %?\n\n%x")
            ("i" "Idea" entry (file+headline ,(expand-file-name "main.org" org-directory) "Ideas")
             "* %? \n%t"))
          org-agenda-skip-deadline-if-done t
          org-agenda-skip-scheduled-if-done t
          org-want-todo-bindings t
          org-hide-emphasis-markers t
          org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)" "CANC(c)"))
          org-startup-truncated nil
          org-startup-folded 'content
          org-ellipsis "▼"
          org-babel-load-languages '((emacs-lisp . t)
                                     (R . t)
                                     (python . t)
                                     (clojure . t)
                                     (sql . t))
          org-babel-clojure-backend 'cider
          nrepl-sync-request-timeout nil
          org-confirm-babel-evaluate nil
          org-file-apps '((auto-mode . emacs))
          org-insert-heading-respect-content t
          org-refile-targets (quote ((nil :maxlevel . 9) (org-agenda-files :maxlevel . 9)))
          org-startup-with-inline-images t
          org-agenda-custom-commands '())

    ;; Make sure org-reveal is loaded
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

    ;; Adding duckdb to org-babel
    (add-to-list 'org-babel-load-languages '(duckdb . t))
    (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)
    (add-to-list 'org-src-lang-modes '("duckdb" . sql)))

  ;; === Clojure ===
  (with-eval-after-load 'cider
    ;; Just the project name in REPL buffer like *clj:my-project*
    (setq cider-session-name-template "clj:%p"))
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(package-selected-packages
     '(a ac-ispell ace-jump-helm-line ace-link ace-window aggressive-indent
         all-the-icons auto-compile auto-complete auto-highlight-symbol
         auto-yasnippet blacken bmx-mode browse-at-remote centered-cursor-mode
         cfrs cider cider-eval-sexp-fu clean-aindent-mode clojure-mode
         clojure-snippets closql code-cells code-review column-enforce-mode
         company-anaconda company-lua csv-mode cython-mode deferred define-word
         devdocs diminish dired-quick-sort dotenv-mode drag-stuff dumb-jump
         editorconfig elisp-def elisp-slime-nav emacsql emmet-mode emojify emr
         esh-help eshell-prompt-extras eshell-z ess-R-data-view evil-anzu
         evil-args evil-cleverparens evil-collection evil-easymotion evil-escape
         evil-evilified-state evil-exchange evil-goggles evil-iedit-state
         evil-indent-plus evil-lion evil-lisp-state evil-matchit evil-mc
         evil-nerd-commenter evil-numbers evil-org evil-surround evil-textobj-line
         evil-tutor evil-unimpaired evil-visual-mark-mode evil-visualstar
         expand-region eyebrowse fancy-battery flx-ido flycheck-elsa
         flycheck-package flycheck-pos-tip forge fsharp-mode fuzzy ggtags gh-md
         ghub git-commit git-gutter-fringe git-link git-messenger git-modes
         git-timemachine gitignore-templates gnuplot golden-ratio google-translate
         gptel haml-mode helm helm-ag helm-c-yasnippet helm-cider helm-company
         helm-css-scss helm-descbinds helm-git-grep helm-ls-git helm-lsp helm-make
         helm-mode-manager helm-org helm-org-rifle helm-projectile helm-purpose
         helm-pydoc helm-swoop helm-themes helm-xref hide-comnt
         highlight-indentation highlight-numbers highlight-parentheses hl-todo
         holy-mode htmlize hungry-delete hybrid-mode importmagic indent-guide
         info+ inspector ivy link-hint live-py-mode lorem-ipsum lsp-mode
         lsp-origami lsp-pyright lsp-python-ms lsp-treemacs lsp-ui lua-mode
         macrostep magit magit-section markdown-mode markdown-toc mmm-mode
         multi-line multi-term mwim nameless nose nrepl-sync open-junk-file
         org-cliplink org-contrib org-download org-mime org-pomodoro org-present
         org-projectile org-re-reveal org-rich-yank org-superstar orgit overseer
         ox-reveal paradox parseedn password-generator pcre2el pip-requirements
         pipenv pippel poetry popwin powershell prettier-js pug-mode py-isort
         pydoc pyenv-mode pylookup pytest quickrun rainbow-delimiters request
         restart-emacs scss-mode sesman shell-pop simple-httpd slim-mode
         smartparens smeargle space-doc spaceline spacemacs-purpose-popwin
         spacemacs-whitespace-cleanup sphinx-doc string-edit-at-point
         string-inflection symbol-overlay symon tagedit term-cursor terminal-here
         toc-org toml-mode transient treemacs treemacs-evil treemacs-icons-dired
         treemacs-magit treemacs-persp treemacs-projectile treepy undo-tree unfill
         uuidgen vi-tilde-fringe vim-powerline volatile-highlights web-beautify
         web-mode wfnames which-key winum with-editor writeroom-mode ws-butler
         xterm-color yaml yaml-mode yapfify yasnippet yasnippet-snippets)))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   )
  )
