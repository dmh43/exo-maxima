(in-package :cl-user)
(defpackage exo-maxima-test-asd
  (:use :cl :asdf))
(in-package :exo-maxima-test-asd)

(defsystem exo-maxima-test
  :author "dmh43"
  :license ""
  :depends-on (:exo-maxima
               :prove)
  :components ((:module "t"
                :components
                ((:file "exo-maxima"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
