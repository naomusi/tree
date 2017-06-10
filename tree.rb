#! /usr/bin/ruby

def tree(depth,dir)
  f =  Dir.open(dir)
  list = []
  f.each{ |file|
    if (file =~ /^[.]$/ || file =~ /^[.][.]$/)
      next
    end
#    file = file.encode("Shift_JIS", :undef => :replace, :replace => "*")
    list.push(file)
  }

  cnt = 0
  list.sort.each {|file|
#    file = file.encode("UTF-8")
    cnt = cnt +1

    fullpath = dir + "/" + file

    if (File.ftype(fullpath) == "directory")
      if (list.length == cnt)
        printf("%s`-- %s\n",depth,file)
        tree(depth + "    ",fullpath)
      else
        printf("%s|-- %s\n",depth,file)
        tree(depth + "|   ",fullpath)
      end
    else
      if (list.length == cnt)
        printf("%s`-- %s\n",depth,file)
      else
        printf("%s|-- %s\n",depth,file)
      end
    end
 }
end

if (ARGV.size() == 0)
  root_dir = "."
else
  root_dir = ARGV[0]
end
printf("%s\n",root_dir)
tree("",root_dir)
