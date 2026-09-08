;;; test_emacs_kotlin_completion.el --- Kotlin completion tests -*- lexical-binding: t; -*-

(require 'package)
(package-initialize)
(require 'ert)
(require 'cl-lib)
(require 'use-package)
(require 'eglot)

(add-to-list 'load-path
             (or (getenv "EMACS_TEST_LISP_DIRECTORY")
                 (expand-file-name "../../resources/emacs/lisp"
                                   (file-name-directory load-file-name))))
(require 'languages/kotlin)

(defun kotlin-test--candidate (&optional command)
  "Return a completion candidate carrying COMMAND."
  (propertize "DeadlineClientInterceptor"
              'eglot--lsp-item
              (list :label "DeadlineClientInterceptor"
                    :command command)))

(defconst kotlin-test--command
  '(:title "Apply Completion"
    :command "jetbrains.kotlin.completion.apply" :arguments [62]))

(ert-deftest kotlin-completion-runs-command-after-eglot-once ()
  ;; Given
  (dolist (status '(finished exact))
    (let ((state (list nil)) calls
          (candidate (kotlin-test--candidate kotlin-test--command)))
      (cl-letf (((symbol-function 'eglot-execute)
                 (lambda (server command)
                   (push (list server command) calls))))
        ;; When
        (dotimes (_ 2)
          (languages-kotlin--completion-exit
           (lambda (_candidate actual-status)
             (push actual-status calls))
           'kotlin-server state candidate status))
        ;; Then
        (should (equal (reverse calls)
                       (list status (list 'kotlin-server kotlin-test--command))))))))

(ert-deftest kotlin-completion-does-not-execute-on-cancel ()
  ;; Given
  (let ((state (list nil)) exit-status)
    (cl-letf (((symbol-function 'eglot-execute)
               (lambda (&rest _) (ert-fail "Executed cancelled completion"))))
      ;; When
      (languages-kotlin--completion-exit
       (lambda (_candidate status) (setq exit-status status))
       'server state (kotlin-test--candidate kotlin-test--command) 'sole)
      ;; Then
      (should (eq exit-status 'sole))
      (should-not (car state)))))

(ert-deftest kotlin-completion-ignores-other-or-missing-commands ()
  ;; Given
  (dolist (command '(nil (:command "java.completion.onDidSelect")))
    (let (called)
      (cl-letf (((symbol-function 'eglot-execute)
                 (lambda (&rest _) (ert-fail "Executed unrelated command"))))
        ;; When
        (languages-kotlin--completion-exit
         (lambda (&rest _) (setq called t))
         'server (list nil) (kotlin-test--candidate command) 'finished)
        ;; Then
        (should called)))))

(ert-deftest kotlin-completion-stops-if-original-exit-fails ()
  ;; Given
  (cl-letf (((symbol-function 'eglot-execute)
             (lambda (&rest _) (ert-fail "Executed after failed edit"))))
    ;; When / Then
    (should (equal
             (should-error
              (languages-kotlin--completion-exit
               (lambda (&rest _) (error "Edit failed"))
               'server (list nil) (kotlin-test--candidate kotlin-test--command)
               'finished))
             '(error "Edit failed")))))

(ert-deftest kotlin-completion-surfaces-command-errors ()
  ;; Given
  (cl-letf (((symbol-function 'eglot-execute)
             (lambda (&rest _) (error "Server command failed"))))
    ;; When / Then
    (should (equal
             (should-error
              (languages-kotlin--completion-exit
               #'ignore 'server (list nil)
               (kotlin-test--candidate kotlin-test--command) 'finished))
             '(error "Server command failed")))))

(ert-deftest kotlin-completion-preserves-capf-and-captures-server ()
  ;; Given
  (let* ((candidate (kotlin-test--candidate kotlin-test--command))
         (original-exit #'ignore)
         (capf (list 1 5 (list candidate)
                     :annotation-function #'identity
                     :exit-function original-exit))
         wrapped executed)
    (cl-letf (((symbol-function 'eglot-completion-at-point) (lambda () capf))
              ((symbol-function 'eglot-current-server) (lambda () 'server)))
      ;; When
      (setq wrapped (languages-kotlin--completion-at-point)))
    ;; Then
    (should (equal (cl-subseq wrapped 0 3) (cl-subseq capf 0 3)))
    (should (eq (plist-get (nthcdr 3 wrapped) :annotation-function) #'identity))
    (should (eq (plist-get (nthcdr 3 capf) :exit-function) original-exit))
    (cl-letf (((symbol-function 'eglot-execute)
               (lambda (server command) (setq executed (list server command)))))
      (funcall (plist-get (nthcdr 3 wrapped) :exit-function) candidate 'finished)
      (should (equal executed (list 'server kotlin-test--command))))))

(ert-deftest kotlin-completion-passes-through-empty-capf ()
  ;; Given
  (dolist (capf '(nil (1 5 ("example"))))
    (cl-letf (((symbol-function 'eglot-completion-at-point) (lambda () capf)))
      ;; When / Then
      (should (equal (languages-kotlin--completion-at-point) capf)))))

(ert-deftest kotlin-completion-only-changes-kotlin-buffers ()
  ;; Given
  (with-temp-buffer
    (setq major-mode 'java-mode)
    (setq-local completion-at-point-functions '(eglot-completion-at-point t))
    (cl-letf (((symbol-function 'eglot-managed-p) (lambda () t)))
      ;; When
      (languages-kotlin--setup-completion)
      ;; Then
      (should (equal completion-at-point-functions '(eglot-completion-at-point t))))))

(ert-deftest kotlin-completion-reconnect-does-not-duplicate-wrapper ()
  ;; Given
  (with-temp-buffer
    (setq major-mode 'kotlin-mode)
    (setq-local completion-at-point-functions '(eglot-completion-at-point t))
    (cl-letf (((symbol-function 'eglot-managed-p) (lambda () t)))
      ;; When
      (dotimes (_ 2) (languages-kotlin--setup-completion))
      ;; Then
      (should (equal completion-at-point-functions
                     '(languages-kotlin--completion-at-point t))))
    (cl-letf (((symbol-function 'eglot-managed-p) (lambda () nil)))
      (languages-kotlin--setup-completion)
      (should (equal completion-at-point-functions '(t))))
    (add-hook 'completion-at-point-functions #'eglot-completion-at-point nil t)
    (cl-letf (((symbol-function 'eglot-managed-p) (lambda () t)))
      (languages-kotlin--setup-completion)
      (should (equal completion-at-point-functions
                     '(languages-kotlin--completion-at-point t))))))
