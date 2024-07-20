;; This installs and initializes the robot-mode in a clean emacs with the
;; following command:
;;
;; rm -vrf elpa/robot-mode-*/ && emacs -Q --debug-init -l ./robot-mode-init-test.el robot-mode-resources/robot-mode-test-correct-font-lock.robot
;;
;; To run the ERT tests, run the following:
;;
;; rm -vrf elpa/robot-mode-*/ && emacs -batch -Q --debug-init -l ./robot-mode-init-test.el -l ./robot-mode-test.el -f ert-run-tests-batch-and-exit
;;

(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))

(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(setq package-archives
      `(("melpa" . "https://melpa.org/packages/")
	("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
       (package-refresh-contents))
;; Install the robot-mode
(package-install-file (concat user-emacs-directory "../"))

(setq debug-on-error t)

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(add-hook 'prog-mode-hook
	  #'(lambda ()
	      (setq show-trailing-whitespace t)))

(require 'thingatpt)
(defun test-show-symbol ()
  (interactive)
  (message "%s" (thing-at-point 'symbol)))

(global-set-key (kbd "C-c C-s") #'test-show-symbol)

;; Optional
;; (setq robot-mode-retain-point-on-indent t)
;; (setq-default indent-tabs-mode nil)

(message "Finished loading init!")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(ivy robot-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
