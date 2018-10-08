#!/usr/bin/perl

# This is the default test processing script, which is used to pre-process the
# screen output unless you create a <testname>.sh next to your test. The
# script gets one argument ($1), which is the name of the file (currently this
# will always be "screen-output") and the input is piped into the script.

# This implementation here just prints the input unmodified, except that we
# filter part of exception messages, because the types are compiler dependent:

$skip = 0;

while ( <STDIN> )
{
    # this is not strictly necessary because we are going to remove the
    # following lines inside the cmake script, but this makes it easier
    # to generate screen-output files from scratch because the useless
    # lines are already removed.
    next if $_ =~ m/^-- /;
    next if $_ =~ m/^\|/;
    next if $_ =~ m/^VMPEAK/;
    next if $_ =~ m/^Time step loop, CPU/;

    if ($skip>0)
    {
	print "(line in output replaced by default.sh script)\n";
	$skip=$skip-1;
	next;
    }

    if ($_ =~ m/^An error occurred in/)
    {
	$skip=1;
    }

    print "$_";
}
