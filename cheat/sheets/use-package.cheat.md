## use-package
The primary purpose of `use-package` is to configure and (lazily) load Emacs
packages. It interfaces with package managers, which allows it to also ensure
that packages are installed before use.

Thanks to the lazy/on-demand loading of packages it enables, it typically helps
reduce the startup time of Emacs. Behind the scenes `use-package` makes use of
Emacs' `autoload` facility, which lets you register the existence of a function
or macro, but put off loading the file that defines it. The first call to the
function automatically loads the proper library, in order to install the real
definition and other associated code, then runs the real definition as if it had
been loaded all along.

    autoload function filename &optional docstring interactive type

For example,

    (autoload 'ace-jump-mode "ace-jump-mode.el" nil t)


## Configuration
Use the `:init` keyword to execute code *before* a package is loaded. It accepts
one or more forms, up to the next keyword:

    (use-package foo
      :init
      (setq foo-variable t))

Since `:init` is always run, even when the package is configured to be loaded
lazily (deferred), one should restrict this to (1) code that doesn't rely on the
package being loaded and (2) avoid time-consuming calls (since they would be
executed on *every* emacs start, no matter if we actually *need* the package).

Similarly, `:config` can be used to execute code *after* a package is loaded. In
cases where loading is done lazily, this execution is deferred until after the
autoload occurs:

    (use-package foo
      :init
      (setq foo-variable t)
      :config
      (foo-mode 1))


## Lazy (deferred) loading
`use-package` can defer loading of a module until a certain command is invoked.

    (use-package company-lsp
      ;; download the package via package.el if it's not available
      :ensure t
      ;; autoload the package whenever `(company-lsp)` is invoked.
      :commands company-lsp


When you use the `:commands` keyword, it creates `autoload`s for those commands
and defers loading of the package until any command is invoked. The `:commands`
keyword takes either a symbol or a list of symbols.

One can combine the use of `:command` with binding a keyboard shortcut to the
command that will trigger the module to be loaded:

    (use-package ace-jump-mode
      :bind ("C-." . ace-jump-mode))

This does two things: first, it creates an autoload for the `ace-jump-mode`
command and defers loading of `ace-jump-mode` until the command is
invoked. Second, it binds the key `C-.` to that command. After loading, you can
use `M-x describe-personal-keybindings` to see all such keybindings you've set
throughout your .emacs file.

A more literal way to do the exact same thing is:

    (use-package ace-jump-mode
      :commands ace-jump-mode
      :init
      (bind-key "C-." 'ace-jump-mode))

Or, an *even more* verbose way of achieving the same thing:

    (use-package ace-jump-mode
      :defer t
      :init
      (autoload 'ace-jump-mode "ace-jump-mode" nil t)
      (bind-key "C-." 'ace-jump-mode))

Note: `:defer t` is implied whenever `:commands`, `:bind`, `:mode`,
`:interpreter` or `:hook` are used.


## Lazy loading via modes and interpreters
Similar to `:commands` and `:bind`, you can use `:mode` and `:interpreter` to
establish a deferred binding within the `auto-mode-alist` and
`interpreter-mode-alist` variables. The specifier to either keyword can be a
cons cell, a list of cons cells, or a string or regexp:

    (use-package ruby-mode
      ;; load if file ends in .rb
      :mode "\\.rb\\'"
      ;; load if file contains a ruby shebang such as `#!/usr/bin/env ruby`
      :interpreter "ruby")

    ;; The package is "python" but the mode is "python-mode":
    (use-package python
      ;; load if file ends in .py
      :mode ("\\.py\\'" . python-mode)
      ;; load if file contains a python shebang such as `#!/usr/bin/env python`
      :interpreter ("python" . python-mode))


## Lazy loading via hooks
The `:hook` keyword allows adding functions onto hooks, here only the basename
of the hook is required. Thus, all of the following are equivalent:

    (use-package ace-jump-mode
      :hook (prog-mode text-mode))

    (use-package ace-jump-mode
      :hook ((prog-mode text-mode) . ace-jump-mode))

    (use-package ace-jump-mode
      :hook ((prog-mode . ace-jump-mode)
             (text-mode . ace-jump-mode)))

    (use-package ace-jump-mode
      :commands ace-jump-mode
      :init
      (add-hook 'prog-mode-hook #'ace-jump-mode)
      (add-hook 'text-mode-hook #'ace-jump-mode))

When using `:hook` omit the "-hook" suffix if you specify the hook explicitly,
as this is appended by default.

Multiple hooks can trigger loading of a package:

    (use-package ace-jump-mode
      :hook (prog-mode text-mode))

    (use-package ace-jump-mode
      :hook ((prog-mode text-mode) . ace-jump-mode))

    (use-package ace-jump-mode
      :hook ((prog-mode . ace-jump-mode)
             (text-mode . ace-jump-mode)))


The use of `:hook`, `:bind`, `:mode`, `:interpreter`, etc., causes the functions
being hooked to implicitly be read as `:commands` (meaning they will establish
interactive `autoload` definitions for that module, if not already defined as
functions), and so `:defer t` is also implied by `:hook`.


## Notes about lazy loading
In almost all cases you don't need to manually specify `:defer t`. This is
implied whenever `:bind` or `:mode` or `:interpreter` is used. Typically, you
only need to specify `:defer` if you know for a fact that some other package
will do something to cause your package to load at the appropriate time, and
thus you would like to defer loading even though `use-package` isn't creating
any autoloads for you.

You can override package deferral with the `:demand` keyword. Thus, even if you
use `:bind`, using `:demand` will force loading to occur immediately and not
establish an autoload for the bound key.

`:defer [N]` causes the package to be loaded -- if it has not already been --
after `N` seconds of idle time. This can be used to unconditionally load many
packages while still having a rapid startup.


## Conditional loading
You can use the `:if` keyword to predicate the loading and initialization of
modules.

    (use-package edit-server
      :if window-system
      :init
      (add-hook 'after-init-hook 'server-start t)
      (add-hook 'after-init-hook 'edit-server-start t))

The `:disabled` keyword can turn off a module you're having difficulties with,
or stop loading something you're not using at the present time:

    (use-package ess-site
      :disabled
      :commands R)

A package can also be triggered to load after another package via `:after`:

    :after (foo bar)
    :after (:all foo bar)
    :after (:any foo bar)
    :after (:all (:any foo bar) (:any baz quux))
    ;; load when either both foo and bar have been loaded, or
    ;; both baz and quux have been loaded
    :after (:any (:all foo bar) (:all baz quux))


## Package installation.
You can use use-package to load packages from ELPA with `package.el`. This is
particularly useful if you share your .emacs among several machines; the
relevant packages are downloaded automatically once declared in your .emacs. The
`:ensure` keyword causes the package(s) to be installed automatically if not
already present on your system (set `(setq use-package-always-ensure t)` if you
wish this behavior to be global for all packages):

    (use-package magit
      :ensure t)

Note that `:ensure` will install a package if it is not already installed, but
it does not keep it up-to-date.

By default package.el prefers `melpa` over `melpa-stable` due to the versioning
`(> evil-20141208.623 evil-1.0.9)`, so even if you are tracking only a single
package from melpa, you will need to tag all the non-melpa packages with the
appropriate archive.

One can use `:pin` to pin a certain package to a certain archive.

    (use-package company
      :ensure t
      :pin melpa-stable)


## Local packages
If your package needs a directory added to the load-path in order to load, use
`:load-path`. This takes a symbol, a function, a string or a list of strings. If
the path is relative, it is expanded within `user-emacs-directory`:

    (use-package ess-site
      :load-path "site-lisp/ess/lisp/"
      :commands R)


## Key-bindings
As mentioned above, one can set up a (deferred) autoload of a package for a
certain command and also bind that command to a key-binding via:

    (use-package org
      ...
      :bind (("C-c o o" . my-org-open)
             ("C-c o l" . org-store-link)
             ("C-c o c" . org-capture)
             ("C-c o a" . org-agenda))
      ...

One can also use `:bind` to set up custom key-bindings _within_ a local keymap
that only exists after the package is loaded via a `:map` modifier:

    (use-package org
      ...
      :bind (("C-c o o" . my-org-open)         ;; global, auto-loading command
             :map org-mode-map                 ;; local key-bindings after load
             ("C-c o x" . org-archive-subtree)
             ("C-c o >" . org-clock-in)
             ("C-c o <" . org-clock-out)
      ...

The effect of the `:map` statement is to wait until `org-mode` has loaded, and
then to bind e.g. `C-c o x` to `org-archive-subtree` within org-mode's local
keymap, `org-mode-map`. Something similar can also be achieved via:

(define-key projectile-mode-map (kbd "C-c s p") 'counsel-projectile-ag)

    (use-package org
      ...
      :bind (("C-c o o" . my-org-open))
      :config
      (define-key org-mode-map (kbd "C-c o x") 'org-archive-subtree)
      ...
