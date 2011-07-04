#!/usr/bin/perl
print "Convert an entire directory of images to thumbs or
to lower resolution images suitable for the web.\n";
print "Create small thumbs? (y/n) ";
chomp ($thumbs = <STDIN>);
if ($thumbs eq "y") {
  print "Size in pixels? ";
  chomp ($thumbsize = <STDIN>);
  $thumbparam = $thumbsize;
  $thumbparam .= "x";
  $thumbparam .= $thumbsize;
} # End if

print "Create larger pictures too? (y/n) ";
chomp ($large = <STDIN>);
if ($large eq "y") {
  print "Size in pixels? ";
  chomp ($largesize = <STDIN>);
  $largeparam = $largesize;
  $largeparam .= "x";
  $largeparam .= $largesize;
} # End if

@listing = `ls`;
foreach $filename (@listing) {
  # Make thumbnails
  if ($thumbs eq "y") {
    chomp($filename);
    $_ = $thumbname = $filename;
    s/\.jpg//;
    $thumbname = $_;
    $thumbname .= "_thumb";
    $thumbname .= ".jpg";
    print "processing... $thumbname\n";
    `convert -size $thumbparam $filename -resize $thumbparam +profile "*" $thumbname`;
  } # End if

  # Make images suitable for the web 
  if ($large eq "y") {
    chomp($filename);
    $_ = $largename = $filename;
    s/\.jpg//;
    $largename = $_;
    $largename .= "_web";
    $largename .= ".jpg";
    print "processing... $largename\n";
    `convert -size $largeparam $filename -resize $largeparam +profile "*" $largename`;
  } # End if
} # End foreach

