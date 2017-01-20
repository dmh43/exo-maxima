(defpackage :exo-maxima
  (:use :common-lisp))

(in-package :exo-maxima)

(let ((*default-pathname-defaults* (truename "./maxima-code/src/")))
  (load "maxima-build.lisp")
  (maxima-load))

(ql:quickload :ningle)
(ql:quickload :clack)
(ql:quickload :cl-ppcre)

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

(defun process-input (input)
  (let* ((input-expression (parse-input input))
         (varlist (get-varlist input-expression))
         (lex-expression (wrap-in-block varlist input-expression)))
    (exo-meval lex-expression)))

(defvar *app* (make-instance 'ningle:<app>))

(setf (ningle:route *app* "/")
      #'(lambda (params)
          (declare (ignore params))
          (with-open-file (stream "./index.html")
            (let ((data (make-string (file-length stream))))
              (read-sequence data stream)
              data))))

(setf (ningle:route *app* "/maxima" :method :POST)
      #'(lambda (params)
          (let ((input-expression (cdr (assoc "expression" params :test #'string=))))
            (when (check-for-termination input-expression)
              (process-input input-expression)))))

(clack:clackup *app* :port 8080)
