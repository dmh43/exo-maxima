(in-package :cl-user)
(defpackage exo-maxima-asd
  (:use :cl :asdf))
(in-package :exo-maxima-asd)

(defsystem exo-maxima
  :version "0.1"
  :author "dmh43"
  :license ""
  :depends-on (:clack
               :lack
               :caveman2
               :envy
               :cl-ppcre
               :uiop

               ;; for @route annotation
               :cl-syntax-annot

               ;; HTML Template
               :djula

               ;; for DB
               :datafly
               :sxql)
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "maxima" :depends-on ("config"))
                 (:file "web" :depends-on ("view"))
                 (:file "view" :depends-on ("config"))
                 (:file "db" :depends-on ("config"))
                 (:file "config"))))
  :description ""
  :in-order-to ((test-op (load-op exo-maxima-test))))
