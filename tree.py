#! /usr/bin/python

import os
import sys

def tree(depth,dir):
  files = sorted(os.listdir(dir))
  cnt = 0

  for file in files:
    fullpath =  dir + "/" + file
    cnt = cnt + 1

    if os.path.isdir(fullpath):
      if len(files) == cnt:
        print "%s`-- %s"%(depth,file)
        tree(depth + "    " ,fullpath)
      else:
        print "%s|-- %s"%(depth,file)
        tree(depth + "|   " ,fullpath)
    else:
      if len(files) == cnt:
        print "%s`-- %s"%(depth,file)
      else:
        print "%s|-- %s"%(depth,file)

root_dir = "."
if len(sys.argv) > 1:
  root_dir = sys.argv[1]

print root_dir
tree("",root_dir)
