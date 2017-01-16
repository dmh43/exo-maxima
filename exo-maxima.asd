(asdf:defsystem #:exo-maxima
  :serial t
  :description "exo-maxima"
  :depends-on (#:clack
               #:ningle)
  :components ((:file "package")
	       (:module :src
			:serial t
			:components ((:file "exo-maxima")))))
