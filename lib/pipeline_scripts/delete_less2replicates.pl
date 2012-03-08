#!/usr/bin/perl

use strict;
use warnings;

my ($input_file, $output_filtered, $output_deleted) = @ARGV;

    use List::MoreUtils qw/all/;
	
	# Open input file
	open( my $PROTEINSLIST3, '<', $input_file ) || die("Couldn't open file $input_file : $!");

	# Open output files for proteins
	open( my $PROTFILTERED3, '>', $output_filtered ) || die("Couldn't open file $output_filtered : $!");
	open( my $PROTDELETED3,  '>', $output_deleted )  || die("Couldn't open file $output_deleted : $!");

	# Get header line
	my $input_line = <$PROTEINSLIST3>;
	$input_line =~ s/[\t\n\r]{1,}$//s;

	#Get interesting column positions
	my @proteins_columnheaders                    = split( /[\t]/, $input_line );
	my %proteins_headers                          = ();
	@proteins_headers{@proteins_columnheaders} = ( 0 .. $#proteins_columnheaders );
	my ( $columnname_prot_HLratio, $columnname_prot_PEP ) = ( "Ratio H/L", 'PEP' );
	my $pos_prot_PEP = $proteins_headers{$columnname_prot_PEP};

	#Ratio values
	my @ratio_MQvalue = ($columnname_prot_HLratio);    #duplex SILAC: only H/L
	#    = ( $columnname_prot_HLratio, 'Ratio H/M', 'Ratio M/L', ); #triplex SILAC

	#Value type
	my @label_MQvalue =
	  ( '', ' Normalized', ' Significance(A)', ' Significance(B)', ' Variability [%]', ' Count' );    #Old MaxQuant computed values

	#Extract experiment labels
    my @labels_prot_experiments = (' 20h', ' 6h', ' ATPase');
	#print join('*', @labels_prot_experiments)."\n";

	my @replicates = (' exp14 rep1', ' exp14 rep2', ' exp14 rep3');
	
    my $total_nb_ratio_cases = ( scalar(@ratio_MQvalue) * scalar(@labels_prot_experiments) * scalar(@replicates) );

	print $PROTFILTERED3 join( "\t", @proteins_columnheaders[ 0 .. $pos_prot_PEP ] ) ;
	print $PROTDELETED3 join( "\t", @proteins_columnheaders[ 0 .. $pos_prot_PEP ] ) ;
    foreach my $ratiotype (@ratio_MQvalue) {
        foreach my $exp (@labels_prot_experiments) {
            foreach my $rep (@replicates) {
                my @one_rep_all_headers = map { $ratiotype . $_ . $rep . $exp } @label_MQvalue;
                # Copy them in outputs
                print $PROTFILTERED3 "\t".join( "\t", @one_rep_all_headers );
	            print $PROTDELETED3 "\t".join( "\t", @one_rep_all_headers );
            }
        }
    }

    print $PROTFILTERED3 "\n";
    print $PROTDELETED3 "\n";

  PROTEINSLOOP3:
    while ( $input_line = <$PROTEINSLIST3> ) {

        $input_line =~ s/[\t\n\r]{1,}$//s;    # problem with chomp?
        my @columns = split( /[\t]/, $input_line );

        my $filtered_line = join( "\t", @columns[ 0 .. $pos_prot_PEP ] ) . "\t";
        my $deleted_line = join( "\t", @columns[ 0 .. $pos_prot_PEP ] ) . "\t";
        my $count_ratiosok = 0;

        foreach my $ratiotype (@ratio_MQvalue) {
            foreach my $exp (@labels_prot_experiments) {
            	
                my @exp_label_headers =  map { $_ . $exp } @replicates;
            	my @norm_ratio_headers = map { $ratiotype . ' Normalized' . $_  } @exp_label_headers;
            	
            	
                my @norm_ratio_pos = @proteins_headers{ @norm_ratio_headers };
                my @norm_ratio_values = @columns[@norm_ratio_pos];
                
                my $count =0;
                foreach my $norm_ratio (@norm_ratio_values) {
                	$count++ if(defined($norm_ratio) && length($norm_ratio)>0);
                }
                if( $count >= 2 ) {
                	
                	foreach my $rep (@replicates) {
                		my @one_rep_all_headers = map { $ratiotype . $_ . $rep . $exp } @label_MQvalue;
                		#print join('*', @one_rep_all_headers)."\n";
                		
                		my @all_ratio_pos    = @proteins_headers{@one_rep_all_headers};
                        my @all_ratio_values = @columns[@all_ratio_pos];
                        @all_ratio_values = map {defined($_)?$_:''} @all_ratio_values;
                        $filtered_line .= join( "\t", @all_ratio_values ) . "\t";
                        $count_ratiosok++;
                		
                        $deleted_line .= "\t" x scalar(@all_ratio_values);
                	}
                	
                	
                }
                else {
                	
                    foreach my $rep (@replicates) {
                        my @one_rep_all_headers = map { $ratiotype . $_ . $rep . $exp } @label_MQvalue;
                        #print join('*', @one_rep_all_headers)."\n";
                        
                        my @all_ratio_pos    = @proteins_headers{@one_rep_all_headers};
                        my @all_ratio_values = @columns[@all_ratio_pos];
                        @all_ratio_values = map {defined($_)?$_:''} @all_ratio_values;
                        $deleted_line .= join( "\t", @all_ratio_values ) . "\t";
                        
                        $filtered_line .= "\t" x scalar(@all_ratio_values);
                    }

                }
                
            	
            }
        }
        
        if ( $count_ratiosok > 0 ) {    
            print $PROTFILTERED3 $filtered_line . "\n";
            print $PROTDELETED3 $deleted_line . "\n" if ( $count_ratiosok != $total_nb_ratio_cases );
        }
        else {
            print $PROTDELETED3 $deleted_line . "\n";
        }

        
    }

	close($PROTEINSLIST3);
	close($PROTFILTERED3);
	close($PROTDELETED3);
