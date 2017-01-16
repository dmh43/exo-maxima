(in-package :cl-user)

(print ">>> Building system....")

(let ((*default-pathname-defaults* (merge-pathnames "maxima-code/" *build-dir*)))
  (load (merge-pathnames "maxima-code/configure.lisp" *build-dir*))
  (configure :interactive nil))

(let ((*default-pathname-defaults* (merge-pathnames "maxima-code/src/" *build-dir*)))
  (load (merge-pathnames "maxima-code/src/maxima-build.lisp" *build-dir*))
  (maxima-compile)
  ;; (load (merge-pathnames "maxima-code/src/maxima-build.lisp" *build-dir*))
  ;; (maxima-load)
  ;; (maxima-dump)
  )

(ql:quickload :static-vectors)

(load (merge-pathnames "maxima-code/src/maxima.asd" *build-dir*))

(ql:quickload :maxima)
;;(load (merge-pathnames "exo-maxima.asd" *build-dir*))
;;(ql:quickload :exo-maxima)

;;; Redefine / extend heroku-toplevel here if necessary.

(print ">>> Done building system")
