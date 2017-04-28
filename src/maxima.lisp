(in-package :cl-user)
(defpackage exo-maxima.maxima
  (:use :cl)
  (:import-from :exo-maxima.config
                :config)
  (:import-from :datafly
                :*connection*)
  (:import-from :cl-dbi
                :connect-cached)
  (:export ;;:load-maxima
           :process-input
           :exo-meval
           :wrap-in-block
           :get-varlist
           :parse-input
           :check-for-termination))
(in-package :exo-maxima.maxima)

;; (defmethod asdf:perform :around ((o asdf:load-op)
;;                                  (c asdf:cl-source-file))
;;   (handler-case (call-next-method o c)
;;     ;; If a fasl was stale, try to recompile and load (once).
;;     (sb-ext:invalid-fasl ()
;;       (asdf:perform (make-instance 'asdf:compile-op) c)
;;       (call-next-method))))

;; ;;(truename "../quicklisp/dists/maxima/software/maxima-5.36.0.1/src/")
;; (defpackage make (:lock nil)) ; hack to declare the package but allow it to be
;;                               ; overwritten when loading maxima-build.lisp
;; (defun load-maxima (maxima-path)
;;   (let ((*default-pathname-defaults* maxima-path)
;;         (*on-package-variance* '(:warn (:swank :swank-backend) :error t)))
;;     (load "configure.lisp")
;;     (configure :interactive nil)
;;     (let ((*default-pathname-defaults* (merge-pathnames #P"src/" maxima-path)))
;;       (load "maxima-build.lisp")
;;       (let (;; (make::*compile-during-load* t)
;;             )
;;         (maxima-load)))))
;; (load-maxima (truename "../quicklisp/dists/maxima/software/maxima-5.36.0.1/"))

(defun load-maxima (maxima-path)
  (let ((*default-pathname-defaults* maxima-path))
    (load "configure.lisp")
    (configure :interactive nil)
    (let ((*default-pathname-defaults* (merge-pathnames #P"src/" maxima-path)))
      (load "maxima-build.lisp")
      (maxima-load))))
(defpackage maxima (:lock nil)) ; hack to declare the package but allow it to
                                ; be overwritten when loading maxima-build.lisp
(load-maxima (truename "../quicklisp/dists/maxima/software/maxima-master/"))

(defun check-for-termination (input)
  (or (search "$" input :test #'char-equal)
      (search ";" input :test #'char-equal)))

(defun parse-input (input)
  (maxima::macsyma-read-string input))

(defun get-varlist (expression)
  (cdr (maxima::$listofvars expression)))

(defun wrap-in-block (varlist expression)
  `((MAXIMA::MPROG) ((MAXIMA::MLIST) ,@varlist) ,expression))

(defun exo-meval (expression)
  (let* ((result (maxima::meval* expression))
         (output-elems (maxima::strgrind result))
         (output-string (format nil "~{~A~}" output-elems)))
    (format t output-string)
    output-string))

(defun process-input (input symbolic-p)
  (let* ((input-expression (parse-input input))
         (varlist (get-varlist input-expression))
         (lex-expression (wrap-in-block varlist input-expression)))
    (if symbolic-p
        (prin1-to-string (maxima::meval* lex-expression))
        (exo-meval lex-expression))))
