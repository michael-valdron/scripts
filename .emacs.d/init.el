;;; init --- Summary
;;; Commentary:
;;; code:
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(cider-auto-mode t)
 '(custom-enabled-themes (quote (dracula)))
 '(custom-safe-themes
   (quote
    ("274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e" "5057614f7e14de98bbc02200e2fe827ad897696bfd222d1bcab42ad8ff313e20" default)))
 '(fci-rule-color "#969896")
 '(indent-tabs-mode nil)
 '(jdee-server-dir "~/jdee-server")
 '(nrepl-message-colors
   (quote
    ("#183691" "#969896" "#a71d5d" "#969896" "#0086b3" "#795da3" "#a71d5d" "#969896")))
 '(package-selected-packages
   (quote
    (neotree dracula-theme github-theme auctex ac-math pyvenv git hy-mode jedi company-jedi ipython-shell-send flycheck-clojure flycheck-pycheckers flymake-python-pyflakes company-anaconda company-shell anaconda-mode template-overlays omnisharp csharp-mode
             (quote company)
             (quote company-mode)
             ac-cider cider-eval-sexp-fu gradle-mode jdee lsp-java eclim javadoc-lookup java-snippets java-imports javaimp javap-mode company ensime sbt-mode markdown-toc markdown-mode+ markdown-mode company-go go-fill-struct go-scratch go-errcheck go-tag go-stacktracer go-snippets go-imenu go-playground-cli go-impl go-autocomplete go-complete go-gopath go-projectile go-playground go-imports golint go-mode clojars cider-hydra cider cython-mode ## clojure-mode scala-mode auto-complete-clang auto-complete-c-headers)))
 '(pdf-view-midnight-colors (quote ("#969896" . "#f8eec7")))
 '(tab-width 4)
 '(vc-annotate-background "#b0cde7")
 '(vc-annotate-color-map
   (quote
    ((20 . "#969896")
     (40 . "#183691")
     (60 . "#969896")
     (80 . "#969896")
     (100 . "#969896")
     (120 . "#a71d5d")
     (140 . "#969896")
     (160 . "#969896")
     (180 . "#969896")
     (200 . "#969896")
     (220 . "#63a35c")
     (240 . "#0086b3")
     (260 . "#795da3")
     (280 . "#969896")
     (300 . "#0086b3")
     (320 . "#969896")
     (340 . "#a71d5d")
     (360 . "#969896"))))
 '(vc-annotate-very-old-color "#969896"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-hook 'go-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends) '(company-go))
            (company-mode)))

(defun install-plugins ()
  (interactive)
  (let* ((packages '(company ac-cider auto-complete cider-eval-sexp-fu gradle-mode
                             jdee lsp-java eclim javadoc-lookup java-snippets
                             java-imports javaimp javap-mode company ensime
                             sbt-mode markdown-toc markdown-mode+ markdown-mode
                             pyvenv anaconda-mode company-go go-fill-struct go-scratch
                             go-errcheck go-tag go-stacktracer go-snippets
                             go-imenu go-playground-cli go-impl go-autocomplete
                             go-complete go-gopath go-projectile go-playground
                             go-imports golint go-mode clojars cider-hydra
                             cider cython-mode clojure-mode scala-mode
                             auto-complete-clang auto-complete-c-headers
                             csharp-mode omnisharp))
         (packages-new))
    (package-refresh-contents)
    (dolist (p packages packages-new)
      (package-install p)
      (setq packages-new (cons p packages)))))

(eval-after-load
  'company
  '(add-to-list 'company-backends #'company-omnisharp))

(defun enable-python-env (env)
  "ARGS: ENV."
  (interactive "senv: ")
  (pyvenv-mode 1)
  (pyvenv-activate (concat "~/anaconda3/envs/" env "/"))
  (jedi:ac-setup))

(defun disable-python-env ()
  "Disable current python env."
  (interactive)
  (pyvenv-deactivate)
  (pyenv-mode 0))

(defun cs-mode-setup ()
  (omnisharp-mode)
  (company-mode)
  (flycheck-mode)

  (setq indent-tabs-mode nil)
  (setq c-syntactic-indentation t)
  (c-set-style "ellemtel")
  (setq c-basic-offset 4)
  (setq truncate-lines t)
  (setq tab-width 4)
  (setq evil-shift-width 4)

  (local-set-key (kbd "C-c r r") 'omnisharp-run-code-action-refactoring)
  (local-set-key (kbd "C-c C-c") 'recompile))

(add-hook 'csharp-mode-hook 'cs-mode-setup t)

(global-company-mode t)
(global-flycheck-mode t)
(global-set-key [?\C-x ?\M-x] 'company-complete)
(global-set-key [f8] 'neotree-toggle)
(global-set-key (kbd "C-x /") 'comment-or-uncomment-region)
(provide 'init)
;;; init.el ends here
(put 'upcase-region 'disabled nil)
