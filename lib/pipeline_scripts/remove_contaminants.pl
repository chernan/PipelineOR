#!/usr/bin/perl

#Description:
#* 00_remove_contaminants.pl
#The script doing the filtering.
#* to_be_removed.txt
#List of protein ids considered as potential contaminants.
#
#Usage:
#- Put boths files into a folder containing a proteinGroups.txt
#- Double click on 00_remove_contaminants.pl to run it.
#- Two new files should be created: 
#proteinGroups_filtered.txt (list of the groups passing the filter) and proteinGroups_deleted.txt (list of the groups containing a protein considered as a contaminant)
#
#Version 0.3 - 03/10/2011
# Command line arguments.
# Changed name to : "00_remove_contaminants.pl"
#Version 0.2 - 26/09/2011
#


use strict;
use warnings;

my ($proteins_list, $to_be_removed_list, 
    $output_filtered, $output_deleted) = ('', '', '', '' );

if(scalar(@ARGV) > 0 ) {
	($proteins_list, $to_be_removed_list, $output_filtered, $output_deleted) = @ARGV;
}
else {
    $proteins_list = 'proteinGroups.txt';
    $to_be_removed_list = 'to_be_removed.txt';
	$output_filtered = 'proteinGroups_filtered.txt';
	$output_deleted = 'proteinGroups_deleted.txt';
}

open(my $TOBEREMOVED, '<', $to_be_removed_list) or die "Could not open $to_be_removed_list : $!";
my $comment_rep1   = <$TOBEREMOVED>;
my $header_rep1   = <$TOBEREMOVED>;
my @columnheaders_rep1 = split( /[\t]/, $header_rep1 );
my %headers_rep1 = ();
@headers_rep1{@columnheaders_rep1} = ( 0 .. @columnheaders_rep1 );
#Protein IDs	Protein Names	Protein Descriptions	Uniprot	Uniprot Name
my ( $columnname_refid, ) = ( "Protein IDs", );
my ( $pos_header_refid ) = $headers_rep1{ $columnname_refid };

my $line;
my %hash_toberemoved = ();
ALLDELIDS:
while(defined($line = <$TOBEREMOVED>)) {

	chomp($line);
	
	my @columns = split( /[\t]/, $line );
	my $refid = $columns[$pos_header_refid];
	$refid =~ s/[\s\n]+//;
	next ALLDELIDS if( !defined($refid) || $refid eq '');

	my @values = (split(/;/, $refid));
	
	foreach my $val (@values) {
		$val = substr($val, 0, length($val)-2) if($val =~ /[.][\d]$/);
		$hash_toberemoved{$val} = '';
	} 
	
}
close($TOBEREMOVED);


open(my $TOBEFILTERED, '<', $proteins_list) or die "Could not open $proteins_list : $!";
open(my $FILTEREDLIST, '>', $output_filtered) or die "$output_filtered : $!";
open(my $DELETEDLIST, '>', $output_deleted) or die "$output_deleted : $!";

my $header_pg   = <$TOBEFILTERED>;
my @columnheaders_pg = split( /[\t]/, $header_pg );
my %headers_pg = ();
@headers_pg{@columnheaders_pg} = ( 0 .. @columnheaders_pg );
my ( $columnname_refid_pg, ) = ( "Protein IDs", );
my ( $pos_header_refid_pg ) = $headers_pg{ $columnname_refid_pg };

print $DELETEDLIST "$header_pg";
print $FILTEREDLIST "$header_pg";

ALLPGIDS:
while(defined($line = <$TOBEFILTERED>)) {

	chomp($line);

	my @columns = split( /[\t]/, $line );
	my $refid = $columns[$pos_header_refid_pg];
	$refid =~ s/[\s\n]+//;
	next ALLPGIDS if( !defined($refid) || $refid eq '');

	my @values = (split(/;/, $refid));
	
	foreach my $val (@values) {
		$val = substr($val, 0, length($val)-2) if($val =~ /[.][\d]$/);
		if(defined($hash_toberemoved{$val})) {
			#print "$val\n";
			print $DELETEDLIST "$line\n";
			next ALLPGIDS;
		}
	}
	print $FILTEREDLIST "$line\n";

}


close($TOBEFILTERED);
close($FILTEREDLIST);
close($DELETEDLIST);