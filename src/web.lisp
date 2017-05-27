(in-package :cl-user)
(defpackage exo-maxima.web
  (:use :cl
        :caveman2
        :exo-maxima.config
        :exo-maxima.view
        :exo-maxima.db
        :exo-maxima.maxima
        :datafly
        :sxql)
  (:export :*web*))
(in-package :exo-maxima.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

(defun handle-maxima-request (expression symbolic-p)
  (handler-case (with-output-to-string (s)
                  (format s
                          (when (check-for-termination expression)
                            (process-input expression symbolic-p))))
    (sb-int:simple-control-error (condition)
      (let ((response (context :response)))
        (print condition)
        (setf (response-status response) 400
              (response-body response) "Invalid input or unsupported functionality.")))
    (sb-kernel:case-failure (condition)
      (let ((response (context :response)))
        (print condition)
        (setf (response-status response) 400
              (response-body response) "Missing statement termination
              token. Make sure the expression to evaluate ends with
              a ; to signal the end of input (see Maxima documentation
              for more info)")))))

(defroute ("/maxima" :method :get) (&key |expression|)
  (handle-maxima-request |expression| nil))

(defroute ("/maxima/symbolic" :method :get) (&key |expression|)
  (handle-maxima-request |expression| t))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
