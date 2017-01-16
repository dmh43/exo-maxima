(defpackage :exo-maxima
  (:use :common-lisp))

(in-package :exo-maxima)

;;(ql:quickload :maxima)
(load "./maxima-code/configure.lisp")
(configure :interactive nil)
(load "./maxima-code/src/maxima-build.lisp")
(maxima-compile)
(load "./maxima-code/src/maxima-build.lisp")
(maxima-load)

(ql:quickload :ningle)
(ql:quickload :clack)

(defvar *app* (make-instance 'ningle:<app>))

(setf (ningle:route *app* "/")
      #'(lambda (params)
          (with-open-file (stream "./index.html")
            (let ((data (make-string (file-length stream))))
              (read-sequence data stream)
              data))))

(setf (ningle:route *app* "/maxima" :method :POST)
      #'(lambda (params)
          (let* ((expression (cdr (assoc "expression" params :test #'string=)))
                 (parsed (maxima::macsyma-read-string expression))
                 (result (maxima::meval* parsed))
                 (elems (maxima::strgrind result))
                 (output-string (format nil "~{~A~}" elems)))
            (format t output-string)
            output-string)))

(clack:clackup *app* :port 80)
