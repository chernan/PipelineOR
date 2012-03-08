#!/usr/bin/perl

use strict;
use warnings;

my ($input_file, $output_filtered, $output_deleted) = @ARGV;

    # Open input file
    open( my $PROTEINSLIST1, '<', $input_file ) || die("Couldn't open file $input_file : $!");

    # Open output files for proteins
    open( my $PROTFILTERED1, '>', $output_filtered ) || die("Couldn't open file $output_filtered : $!");
    open( my $PROTDELETED1,  '>', $output_deleted )  || die("Couldn't open file $output_deleted : $!");

    # Get header line
    my $input_line = <$PROTEINSLIST1>;

    # Copy it in outputs
    print $PROTFILTERED1 $input_line;
    print $PROTDELETED1 $input_line;

    #Get interesting column positions
    $input_line =~ s/[\t\n\r]{1,}$//s;
    my @proteins_columnheaders                    = split( /[\t]/, $input_line, -1 );
    my %proteins_headers                          = ();
    @proteins_headers{@proteins_columnheaders} = ( 0 .. $#proteins_columnheaders );
    my ( $columnname_prot_rev, $columnname_prot_cont, $columnname_prot_onlysite ) =
      ( 'Reverse', 'Contaminant', 'Only identified by site' );
    my $pos_cont_info     = $proteins_headers{$columnname_prot_cont};
    my $pos_rev_info      = $proteins_headers{$columnname_prot_rev};
    my $pos_onlysite_info = $proteins_headers{$columnname_prot_onlysite};

  PROTEINSLOOP1:
    while ( $input_line = <$PROTEINSLIST1> ) {

        $input_line =~ s/[\t\n\r]{1,}$//s;    # problem with chomp?
        my @columns = split( /[\t]/, $input_line, -1 );

        # Remove reverse and contaminant proteins
        if ( defined( $columns[$pos_cont_info] ) && $columns[$pos_cont_info] =~ /[+0]/ ) {
            print $PROTDELETED1 "$input_line\n";
            next PROTEINSLOOP1;
        }
        if ( defined( $columns[$pos_rev_info] ) && $columns[$pos_rev_info] =~ /[+0]/ ) {
            print $PROTDELETED1 "$input_line\n";
            next PROTEINSLOOP1;
        }
        if ( defined( $columns[$pos_onlysite_info] ) && $columns[$pos_onlysite_info] =~ /True/ ) {
            print $PROTDELETED1 "$input_line\n";
            next PROTEINSLOOP1;
        }

        print $PROTFILTERED1 "$input_line\n";
    }

    close($PROTEINSLIST1);
    close($PROTFILTERED1);
    close($PROTDELETED1);
