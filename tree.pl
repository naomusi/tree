#! /usr/bin/perl
use utf8;
#use Encode qw/encode decode/;
use Encode;

if (scalar(@ARGV) == 0) {
  $root_dir = "."
}
else {
  $root_dir = shift(@ARGV);
}
printf("%s\n",$root_dir);
&tree("",$root_dir);

sub tree {
  my($depth,$dir) = @_;

  if (!opendir(FD,$dir)) {
    printf("Can't open dir[%s]\n",$dir);
    exit(1);
  }

  my(@list) = ();
  foreach $file (readdir(FD)) {
    if ($file =~ /^[.]$/ || $file =~ /^[.][.]$/) {
      next;
    }
#    $file = decode('UTF-8', $file);
#    $file = encode('Shift_JIS', $file);
    push(@list,$file)
  }
  close(fd);

  my($cnt) = 0;
  foreach $file (sort @list) {
    $cnt++;

#    $file = decode('Shift_JIS', $file);
#    $file = encode('UTF-8', $file);
    my($fullpath) = $dir . "/" . $file;
    if ( -d $fullpath ) {
      if (scalar(@list) == $cnt) {
        printf("%s`-- %s\n",$depth,$file);
        tree($depth . "    ",$fullpath);
      }
      else {
        printf("%s|-- %s\n",$depth,$file);
        tree($depth . "|   ",$fullpath);
      }
    }
    else {
      if (scalar(@list) == $cnt) {
        printf("%s`-- %s\n",$depth,$file);
      }
      else {
        printf("%s|-- %s\n",$depth,$file);
      }
    }
  }
}
