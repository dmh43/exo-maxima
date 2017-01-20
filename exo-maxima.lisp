(defpackage :exo-maxima
  (:use :common-lisp))

(in-package :exo-maxima)

(let ((*default-pathname-defaults* (truename "./maxima-code/src/")))
  (load "maxima-build.lisp")
  (maxima-load))

(ql:quickload :ningle)
(ql:quickload :clack)

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
          (let* ((expression (cdr (assoc "expression" params :test #'string=)))
                 (parsed (maxima::macsyma-read-string expression))
                 (result (maxima::meval* parsed))
                 (elems (maxima::strgrind result))
                 (output-string (format nil "~{~A~}" elems)))
            (format t output-string)
            output-string)))

(clack:clackup *app* :port 8080)
