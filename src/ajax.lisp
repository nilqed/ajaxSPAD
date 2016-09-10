(in-package :boot)

(defun concstr (list)
  ;; concatenate a list of strings ; recall ~% = newline"
  (if (listp list)
      (with-output-to-string (s)
         (dolist (item list)
           (if (stringp item)
             (format s "~a~%" item))))))


(in-package :ht-simple-ajax)


;;; create an ajax processor that will handle our function calls
(defparameter *ajax-processor* 
  (make-instance 'ajax-processor :server-uri "/ajax"))
  
;;; define a function that we want to call from a web app
;;; use ispad-eval like fun to catch tex etc. ...... +todo
(defun-ajax spad_eval (code) (*ajax-processor*)
   (let ((*package* (find-package :boot)))
     (boot::concstr (boot::|parseAndEvalToString| code))))
       
    
;;; add ajax processor to the hunchentoot dispatch table
(setq *dispatch-table* (list 'dispatch-easy-handlers 
  (create-ajax-dispatcher *ajax-processor*)))
                             
                                               
(use-package :cl-who)
 
(defparameter *app-title* "webSPAD")
(defparameter *app-div-id* "console")
(defparameter *app-jquery* "jq-console/jquery-2.1.1.min.js")
(defparameter *app-jconsole* "jq-console/lib/jqconsole.js")
(defparameter *app-type-js* "application/javascript")
(defparameter *app-banner* "webSPAD 1.0.0 [jqConsole]\\n\\n")
(defparameter *app-prompt* "> ")
(defparameter *app-port* 8000)

(defparameter *app-console* (format nil "$(function () 
  {var jqconsole = $('#console').jqconsole('~A', '~A');
   var startPrompt = function () {
   jqconsole.Prompt(true, function (input) 
     { //alert(input);
       var callback = function(response) {
       jqconsole.Write(response.firstChild.firstChild.nodeValue+'\\n',
         'jqconsole-output');}    
       ajax_spad_eval(input,callback);
       // Restart the prompt.
       startPrompt(); });
     };
    startPrompt();
  })" *app-banner* *app-prompt*))


(defparameter *app-style* (format nil 
  "html, body { background-color: #333;
                color: white;
                font-family: monospace;
                margin: 0;
                padding: 0;}
                /* The console container element */
   #console {   height: 400px;
                width: 750px;
                position:relative;
                background-color: black;
                border: 2px solid #CCC;
                margin: 0 auto;
                margin-top: 50px;}
                /* The inner console element. */
  .jqconsole {  padding: 10px;}
                /* The cursor. */
  .jqconsole-cursor {background-color: gray;}
                /* The cursor color when the console looses focus. */
  .jqconsole-blurred .jqconsole-cursor {background-color: #666;}
                /* The current prompt text color */
  .jqconsole-prompt {color: #0d0;}
                /* The command history */
  .jqconsole-old-prompt {color: #0b0;
                         font-weight: normal;}
                /* The text color when in input mode. */
  .jqconsole-input {color: #dd0;}
                /* Previously entered input. */
  .jqconsole-old-input {color: #bb0; 
                        font-weight: normal;}
                /* The text color of the output. */
  .jqconsole-output {color: white;}"))



(define-easy-handler (main-page :uri "/") ()
  (cl-who:with-html-output-to-string (*standard-output* nil :prologue t)
  (:html :xmlns "http://www.w3.org/1999/xhtml"
  (:head
  (:style (princ *app-style*))      
  (:title (princ *app-title*)))
    (:body
      (:div :id *app-div-id*)
        (princ (generate-prologue *ajax-processor*))
        (:script :src *app-jquery* :type *app-type-js*)
        (:script :src *app-jconsole* :type *app-type-js*)
        (:script :type *app-type-js*  (princ *app-console*))))))
        
                                                                                         
                                                                                         
;;; setup and start a hunchentoot web server:
(defparameter *my-server* 
  ;;(start (make-instance 'easy-acceptor :address "localhost" :port 8000)))
   (start (make-instance 'easy-acceptor :port *app-port*)))