(in-package :common-lisp-user)

(asdf:defsystem #:ajaxspad
  :serial t
  :description "Hunchentoot webserver serving SPAD"
  :version "1.0.0"
  :author "Kurt Pagani, <nilqed@gmail.com>"
  :license "BSD, see file LICENSE"
  :pathname "src/"
  :components ((:file "ajaxspad") (:file "ajax")))
