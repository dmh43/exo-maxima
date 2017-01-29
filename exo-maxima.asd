(asdf:defsystem #:exo-maxima
  :serial t
  :description "exo-maxima"
  :depends-on (#:clack
               #:ningle
               #:cl-ppcre)
  :components ((:file "package")
	       (:module :src
			:serial t
			:components ((:file "exo-maxima")))))
