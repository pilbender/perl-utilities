#!/usr/bin/perl
# Filename: ipfilter.pl
# Date: 8-15-2006
# Author: Richard Scott Smith

# The keys in the hash tables are by ip address
# Hash table to store the number of times an ip address has occurred
%iptable;

# Temporary variable to hold the current ip address
$ipaddress;

# Count up the total number of IP addresses that have been processed
$totalNumberOfIPAddresses = 0;

while (<>) {
  if (&identifyIPAddress()) {
    if (exists $iptable{"$ipaddress"}) {
      #print "IP was already in the hash table.\n";
      $iptable{"$ipaddress"} +=1;
    } else {
      $iptable{"$ipaddress"} = 1;
    } # End if-else

    #print "$_\n";
    #print "Total: $numberOfIPAddresses\n";
  } # End if

} # End while

# Sort the iptable frequency into a list
@ipaddress = sort by_frequency keys %iptable;

# Finally print the contents of the iptable
print "IP Table:\n";
foreach (@ipaddress) {
  # Local spaces for nicely printed output
  my ($spaces) = " ";
  print "$_";
  for ($i = length $_; $i < 20; $i++) {
    $spaces .= "-";
  } # End for loop
  $spaces .= " ";
  print $spaces . $iptable{"$_"};
  print "\n";
} # End foreach

print "\n";
print "Total IP addresses scanned: $totalNumberOfIPAddresses\n";

# Identify if a line has an IP address on it
sub identifyIPAddress {
  if (/\d+\.\d+\.\d+\.\d+/) {
    $totalNumberOfIPAddresses += 1;
    $ipaddress = $&;
    #print "Here's an IP: $&\n";
    return 1;
  } else {
    return 0;
  } # End if-else
} # End identifyIPAddress

# Sort value (by frequency)
sub by_frequency {
  $iptable{$b} <=> $iptable{$a}
}
