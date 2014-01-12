#!/usr/bin/perl
# Filename: ping-notifier.pl
# Date: 1-11-2014
# Author: Richard Scott Smith

# This Perl Module issues a wget a server to see if it's still up
# and then stores the results in $HOME/bin/.<server>-counter.txt and 
# $HOME/bin/.<server>-last-status.txt.  Then the module parses through the 
# $HOME/bin/.<server>-last-status.txt file to make sure that response back 
# from the system is valid.  If it's not, then an email is sent out and 
# the $HOME/bin/.<server>-counter.txt file is incremented to indicate 
# it was down.

# Settings
$count_file = ".raescott.homelinux.net-counter.txt";
$status_file = ".raescott.homelinux.net-last-status.txt";
$valid_status_message = "HTTP request sent, awaiting response... 200 OK";
$hostname = "raescott.homelinux.net";
$port = "8";
$email_address = "pilbender\@gmail.com";

# Variable Declarations
$check_counter;    # The number of times a check has been issued
$status = 0;       # No valid response found yet, false.  True once it's found.

# First get the counter and store it.
open COUNTER, $count_file 
  or $check_counter = 0;  # First time the file doesn't exist.
while (<COUNTER>) {
  chomp;
  $check_counter = $_;
}
close COUNTER;

# Try issuing a wget on the glassfish server and store the response in the 
# $status_file.  Toggle the status to 1 if the proper response is received.
system "wget --delete-after $hostname:$port 2>&1 | grep \"HTTP request sent\" > $status_file";
open STATUS, $status_file
  or die "Cannot open $status_file!";
while (<STATUS>) {
  chomp;
  if ($valid_status_message eq $_) {
    $status = 1;
  }
}

# Now update the counter.
if ($status != 1) {
  open COUNTER, ">$count_file"
    or die "Cannot open $count_file!";
  ++$check_counter;
  select COUNTER;
  print $check_counter;
  close COUNTER;

  # Okay we're down, sent out an email
  system "echo \"Failed $check_counter times!\" | mail -s \"$hostname is down!\" $email_address";
}
