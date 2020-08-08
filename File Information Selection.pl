#!/usr/bin/perl -w
use strict;

sub format_error
{

	print "Please use the following syntax to execute the program:\n";
	print "<option: -a, -t, -n> <filename>\n";
	print "<oprion: -s> <time: xx:xx:xx> <filename>\n";

}

sub exist_and_read
{

	my $file = $_[0];

	if(!-e $file)
	{	
		
		print "The file isn't existing!\n";
		exit;

	}

	if(!-r $file)
	{
		
		print "The file is unreadable!\n";
		exit;

	}

}

sub check_empty
{

	my $option = $_[0];
	my $size = $_[1];

	if( $size == 0 && $option eq "-a")
	{

		print "No commands\n";
		exit;

	}

	elsif( $size == 0 && $option eq "-t")
	{

		print "No terminals\n";
		exit;

	}

	elsif( $size == 0 && $option eq "-s")
	{

		print "No processes above threshold\n";
		exit;

	}

}

sub read_file
{
	
	my $hash = $_[0];
	my $file = $_[1];
	my $count = 1;

	open(READ, $file);
	
	while(<READ>)
	{

		chomp;
		my $string = $_;
		$string =~ s/^\s+//;

		my ($id, $terminal, $time, $command) = split(/\s+/, $string);
		
		${${$hash}{$count}}[0] = $id;
		${${$hash}{$count}}[1] = $terminal;
		${${$hash}{$count}}[2] = $time;
		${${$hash}{$count}}[3] = $command;
		
		$count++;

	}
	
	return my $size = $count-1;	
	close(READ);

}

sub command_name
{

	my $i;
	my $hash = $_[0];
	my $size = $_[1];
	
	for($i=1 ; $i<=$size ; $i++)
	{

		print ${${$hash}{$i}}[3]."\n";
	
	}	

}

sub terminal
{
	
	my $i;
	my $hash = $_[0];
	my $size = $_[1];
	my %terminal;	

	for($i=1 ; $i<=$size ; $i++)
	{

		my $key = ${${$hash}{$i}}[1];		

		if(!exists $terminal{$key})
		{
	
			print $key."\n";
			$terminal{$key} = $key;
	
		}

	}

}

sub time_threshold
{
	
	my $i;
	my $count = 0;
	my $hash = $_[0];
	my $size = $_[1];
	my $time = $_[2];
	my ($hour, $minute, $second, $splited_time, $threshold);

	($hour, $minute, $second) = split(/:/, $time);
	$threshold = ($hour*10000)+($minute*100)+$second;
	
	for($i=1 ; $i<=$size ; $i++)
	{
	
		$time = ${${$hash}{$i}}[2];
		($hour, $minute, $second) = split(/:/, $time);
		$splited_time = ($hour*10000)+($minute*100)+$second;
		
		if($splited_time >= $threshold)
		{
			
			my ($id, $terminal, $time, $command);
			$id = ${${$hash}{$i}}[0];
			$terminal = ${${$hash}{$i}}[1];
			$time = ${${$hash}{$i}}[2];
			$command = ${${$hash}{$i}}[3];

			printf("%5s %-8s %8s %s\n", $id, $terminal, $time, $command);
			$count++;
	
		}

	}

	if($count == 0)
	{

		print "No processes above threshold\n";
		exit;

	}	

}



my %filedata;
my $size;

if(@ARGV == 2 || @ARGV == 3)
{

	if(@ARGV == 2 && $ARGV[0] =~ m/-[ant]/)
	{

		exist_and_read($ARGV[1]);
		
		if($ARGV[0] eq "-a")
		{	

			$size = read_file(\%filedata, $ARGV[1]);
			check_empty($ARGV[0], $size);
			command_name(\%filedata, $size);	

		}
		
		elsif($ARGV[0] eq "-t")
		{

			$size = read_file(\%filedata, $ARGV[1]);
			check_empty($ARGV[0], $size);
			terminal(\%filedata, $size);

		}

		elsif($ARGV[0] eq "-n")
		{
			
			print "-----------------------------------------------\n";
			print "					  	      \n";
			print "     Unix Systems Programming, Spring 2019     \n";
			print "                  Assignment		      \n";
			print "						      \n";
			print "         Submitteded By:  Jiaran Ma	      \n";
			print "                          12999278	      \n";
			print "        Completion Date:   		      \n";
			print "                          12-10-2019	      \n";
			print "						      \n";
			print "-----------------------------------------------\n";

		}

	}

	elsif(@ARGV == 3 && $ARGV[0] eq "-s" && $ARGV[1] =~ m/\d\d:\d\d:\d\d/)
	{

		exist_and_read($ARGV[2]);
		$size = read_file(\%filedata, $ARGV[2]);
		check_empty($ARGV[0], $size);
		time_threshold(\%filedata, $size, $ARGV[1]);

	}

	else
	{
		format_error;
	}

}

else
{
	format_error;
}

