;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file is a part of the caveman2-widgets project.
;;
;; Copyright (c) 2016 Richard Paul Bäck (richard.baeck@free-your-pc.com)
;; LICENSE: LLGPLv3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :cl-user)
(defpackage caveman2-widgets.util
  (:use :cl
        :caveman2)
  (:export
   :*application-root*
   :*static-directory*
   :*js-directory*
   :*css-directory*

   :append-item
   :delete-item
   :find-item

   :defroute-static
   :get-trimmed-class-name
   :clean-list-of-broken-links
   :get-value-for-cons-list))
(in-package :caveman2-widgets.util)

(defparameter *application-root* (asdf:system-source-directory :caveman2-widgets))
(defparameter *static-directory* (merge-pathnames #P"static/" *application-root*))
(defparameter *js-directory* (merge-pathnames #P"js/" *static-directory*))
(defparameter *css-directory* (merge-pathnames #P"css/" *static-directory*))

(defun get-trimmed-class-name (obj)
  (let ((class-name (symbol-name (type-of obj))))
    (string-downcase
     (subseq class-name
             1
             (- (length class-name) 1)))))

(defun clean-list-of-broken-links (some-list)
  (declare (list some-list))
  (remove-if #'(lambda (item)
                 (null (trivial-garbage:weak-pointer-value item)))
             some-list))

(defun get-value-for-cons-list (some-list key)
  (declare (string key)
           (list some-list))
  (cdr
   (assoc key
          some-list
          :test #'equal)))

(defun defroute-static (uri-path path app content-type)
  (declare (string uri-path)
           (pathname path)
           (string content-type))
  (setf (ningle:route app
                      uri-path
                      :method :get)
        #'(lambda (params)
            (declare (ignore params))

            (setf (getf (response-headers *response*) :content-type)
                  content-type)

            (let ((ret-val ""))
              (with-open-file (input path :direction :input)
                (loop
                   for line = (read-line input nil 'eof)
                   until (eq line 'eof) do
                     (setf ret-val
                           (format nil "~a~%~a"
                                   ret-val
                                   line))))
              ret-val))))

(defgeneric append-item (this item))

(defmethod append-item ((this t) (item t))
  (error "Not supported yet!"))

(defgeneric delete-item (this item))

(defmethod delete-item ((this t) (item t))
  (error "Not supported yet!"))

(defgeneric find-item (this to-find))

(defmethod find-item ((this t) (item t))
  (error "Not supported yet!"))
