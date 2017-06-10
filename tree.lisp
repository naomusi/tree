#! /usr/bin/clisp

(defun fname-chop(tfile)
  ;;
  (let ((buf (namestring tfile)))
       (setq ch (subseq buf (- (length buf) 1) (length buf)))
       (if (equal ch "/")
           (subseq buf 0 (- (length buf) 1))
           (subseq buf 0 (length buf)))))

(defun tree(depth dir)
  
  (let (
    (list (concatenate 
           'list
           (directory (concatenate 'String dir "*/"))
           (directory (concatenate 'String dir "*"))))
    (tmp "")
    (cnt 0))

    (sort list #'string< :key #'fname-chop)

    (dolist (file list)
      (progn 
        (incf cnt)
        (setq tfile (namestring file))
        (setq tfile (subseq tfile 0 (- (length tfile) 1)))

        (if (equal (file-namestring file) "")
          (if (equal (length list) cnt)
            (progn 
              (format t "~A`-- ~A~%" depth (file-namestring tfile))
              (tree (concatenate 'String depth "    ") (namestring file))
              )
            (progn 
              (format t "~A|-- ~A~%" depth (file-namestring tfile))
              (tree (concatenate 'String depth "|   ") (namestring file))
              ))
          (if (equal (length list) cnt)
            (progn 
              (format t "~A`-- ~A~%" depth (file-namestring file))
              )
            (progn 
              (format t "~A|-- ~A~%" depth (file-namestring file))
              )))))))

(let 
  ((root_dir ""))
  (if (equal (length *args*) 0)
    (setq root_dir "./")
    (setq root_dir (car *args*)))
  (if (not (equal (subseq root_dir (- (length root_dir) 1) (length root_dir)) "/")) 
    (format t "test01 [dir]"))
  (format t "~A~%" root_dir)
  (tree "" root_dir))
