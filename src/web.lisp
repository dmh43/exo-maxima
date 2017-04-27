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

(defroute ("/maxima" :method :post) (&key _parsed)
  (with-output-to-string (s)
    (format
     s
     (let ((input-expression (cdr (assoc "expression" _parsed :test #'string=)))
           (symbolic-p (cdr (assoc "symbolic" _parsed :test #'string=))))
       (when (check-for-termination input-expression)
         (handler-case (process-input input-expression symbolic-p)
           (sb-int:simple-control-error () "invalid input or unsupported functionality")))))))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
