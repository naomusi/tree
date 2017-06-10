import java.io.*;
import java.util.*;

class tree {
  void tree(String depth,File dir) {
    File[] files = dir.listFiles();
    int cnt = 0; 

    Arrays.sort(files);

    if (files == null) {
      return;
    }
    for(File file: files) {
      cnt++;
      if (file.isDirectory()) {
        if (files.length == cnt) {
          System.out.printf("%s`-- %s\n",depth,file.getName());
          tree(depth + "    ",new File(file.getAbsolutePath())); 
        }
        else {
          System.out.printf("%s|-- %s\n",depth,file.getName());
          tree(depth + "|   ",new File(file.getAbsolutePath())); 
        }
      }
      else {
        if (files.length == cnt) {
          System.out.printf("%s`-- %s\n",depth,file.getName());
        }
        else {
          System.out.printf("%s|-- %s\n",depth,file.getName());
        }
      }
    }
  }

  public static void main(String args[]) {
    String root_dir = ".";

    if (args.length != 0) {
      root_dir = args[0];
    }
    System.out.printf("%s\n",root_dir);

    tree obj = new tree();
    obj.tree("",new File(root_dir));
  }
}
