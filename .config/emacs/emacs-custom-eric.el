;; Farvardin's emacs profile

;; visual theme
 
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;; https://ergoemacs.github.io/index.html (shortcuts ctrl+x ctrl+v...)
;;; might clash with emacs console mode (-nw)
;;(setq ergoemacs-theme nil) ;; Uses Standard Ergoemacs keyboard theme
;;(setq ergoemacs-keyboard-layout "fr") ;; Assumes AZERTY keyboard layout
;;(require 'ergoemacs-mode)
;;(ergoemacs-mode 1)

;;; don't use this! (use cua mode instead, see below)
;;(global-set-key (kbd "C-c") 'copy)
;;(global-set-key (kbd "C-x") 'cut)
;;(global-set-key (kbd "C-v") 'yank)

;; use standard keys for undo cut copy paste
;; see https://www.emacswiki.org/emacs/CuaMode
(cua-mode 1)

;; save with ctrl + s
(global-set-key (kbd "C-s") 'save-buffer)


;; normal cursor
(setq-default cursor-type 'bar) 
;;(set-cursor-color "#ffffff") 


;; M-x package-refresh-contents
;; M-x package-install solarized-theme
;; M-x package-install RET gruvbox-theme RET 

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes '(gruvbox-dark-soft))
 '(custom-safe-themes
   '("2ff9ac386eac4dffd77a33e93b0c8236bb376c5a5df62e36d4bfa821d56e4e20" "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "57a29645c35ae5ce1660d5987d3da5869b048477a7801ce7ab57bfb25ce12d3e" default))
 '(font-use-system-font nil)
 '(package-selected-packages '(gruvbox-theme ergoemacs-mode solarized-theme)))
 

;; font size
;; also: C-x C-+ and C-x C-- to increase or decrease the buffer text size
;; also: Press Shift and the first mouse button and use the menu
;; (set-face-attribute 'default nil :height 140)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Zilla Slab" :foundry "TPTQ" :slant normal :weight normal :height 143 :width normal)))))



;; turn word wrap on
(global-visual-line-mode 1)
(setq-default word-wrap t)
;;(add-hook 'text-mode-hook 'turn-on-auto-fill)
;;(toggle-word-wrap)


;; extensions

(add-to-list 'load-path "~/.config/emacs/")

;; txt2tags


(setq auto-mode-alist (append (list
	'("\\.t2t$" . t2t-mode)
	)
	(if (boundp 'auto-mode-alist) auto-mode-alist)
))
(autoload  't2t-mode "txt2tags-mode" "Txt2tags Mode" t)




;; Uxntal

;;; Set location of uxntal-mode.el
;;(add-to-list 'load-path "~/.emacs.d/site-lisp")
;;(add-to-list 'load-path "~/.emacs.d/lisp")

;;; Make sure uxnasm and uxnemu are on your PATH if you want to use uxntal-eval-buffer.
;;; Include any other assemblers if you want to use them, for example ruxnasm.
;;; On OSX we need to set the exec-path.
;;; In linux it appears that if you have the executables in your shell's PATH you can probably skip this step.
;;(setq exec-path (append exec-path '("/Users/xyz/uxn/bin" "/Users/xyz/ruxnasm/target/release")))

;;; If you want to use a different assembler
;;(setq uxntal-assembler "ruxnasm")

;;; Enable the mode and associate with the .tal extension 
;;(require 'uxntal-mode)
;;(add-to-list 'auto-mode-alist '("\\.tal\\'" . uxntal-mode))

;; load uxn / tal-mode (from https://github.com/non/tal-mode)
(require 'tal-mode)


;; tests
;; see https://lucidmanager.org/productivity/configure-emacs/

;  (setq inhibit-startup-message t
;        initial-scratch-message "Hello world"
;        cursor-type 'bar)

;; Keyboard-centric user interface
  (setq inhibit-startup-message t)
;  (tool-bar-mode -1)
;  (menu-bar-mode -1)
;  (scroll-bar-mode -1)
;  (defalias 'yes-or-no-p 'y-or-n-p)


;; menu

(defvar my-menu-bar-menu (make-sparse-keymap "::"))
(define-key global-map [menu-bar my-menu] (cons "::" my-menu-bar-menu))

(define-key my-menu-bar-menu [my-cmd1]
  '(menu-item "Set mono font" my-cmd1 :help "Do what my-cmd1 does"))
(define-key my-menu-bar-menu [my-cmd2]
  '(menu-item "Set other font" my-cmd2 :help "Do what my-cmd2 does"))
  

(defun my-cmd1 () (interactive)
(custom-set-faces
'(default ((t (:family "Space Mono" :foundry "CF  " :slant normal :weight normal :height 128 :width normal)))))
)

(defun my-cmd2 () (interactive)
(custom-set-faces
'(default ((t (:family "Zilla Slab" :foundry "TPTQ" :slant normal :weight normal :height 143 :width normal)))))
)
