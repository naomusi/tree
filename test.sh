#! /bin/sh

#TARGET=/media/naoki/HD-PCTU3/永久保存/
TARGET=$HOME/Dropbox/work/

#echo "== tree command =="
#time tree --charset ascii $TARGET > tmp0
echo "== perl =="
time ./tree.pl   $TARGET > tmp1
echo
echo "== ruby =="
time ./tree.rb   $TARGET > tmp2
echo
echo "== python =="
time ./tree.py   $TARGET > tmp3
echo
echo "== lisp =="
time ./tree.lisp $TARGET > tmp4
echo
echo "== java =="
time java tree   $TARGET > tmp5
echo
echo "== C =="
time ./tree      $TARGET > tmp6
echo
