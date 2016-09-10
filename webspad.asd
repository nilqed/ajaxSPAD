(in-package :common-lisp-user)

(asdf:defsystem #:webspad
  :serial t
  :description "Hunchentoot webserver serving SPAD"
  :version "1.0.0"
  :author "Kurt Pagani, <nilqed@gmail.com>"
  :license "BSD, see file LICENSE"
  :pathname "src/"
  :components ((:file "webspad") (:file "ajax")))
