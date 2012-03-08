#!/usr/bin/perl

use strict;
use warnings;

my ($input_file, $output_filtered, $output_deleted) = @ARGV;

	# Open input file
	open( my $PROTEINSLIST2, '<', $input_file ) || die("Couldn't open file $input_file : $!");

	# Open output files for proteins
	open( my $PROTFILTERED2, '>', $output_filtered ) || die("Couldn't open file $output_filtered : $!");
	open( my $PROTDELETED2,  '>', $output_deleted )  || die("Couldn't open file $output_deleted : $!");

	# Get header line
	my $input_line = <$PROTEINSLIST2>;
	$input_line =~ s/[\t\n\r]{1,}$//s;

	#Get interesting column positions
	my @proteins_columnheaders                    = split( /[\t]/, $input_line );
	my %proteins_headers                          = ();
	@proteins_headers{@proteins_columnheaders} = ( 0 .. $#proteins_columnheaders );
	my ( $columnname_prot_HLratio, $columnname_prot_PEP ) = ( 'Ratio H/L', 'PEP' );
	my $pos_prot_PEP = $proteins_headers{$columnname_prot_PEP};

	#Ratio values
	my @ratio_MQvalue = ($columnname_prot_HLratio);    #duplex SILAC
	#    = ( $columnname_prot_HLratio, 'Ratio H/M', 'Ratio M/L', ); #triplex SILAC

	#Value type
	#my ($label_MQvalue_ratio, $label_MQvalue_rationorm, $label_MQvalue_signA, $label_MQvalue_signB, $label_MQvalue_var, $label_MQvalue_count)
	my @label_MQvalue =
	  ( '', " Normalized", " Significance(A)", " Significance(B)", " Variability [%]", " Count" );    #Old MaxQuant

	#Extract experiment labels
	my @labels_prot_experiments = ();
	my @pos_header_prot_HLratio = @proteins_headers{
		grep {
			     /$columnname_prot_HLratio/
			  && !/Normalized/
			  && !/Variability/
			  && !/Count/
			  && !/Sequence Correlation/
			  && !/Significance\(A\)/
			  && !/Significance\(B\)/
		  } @proteins_columnheaders
	  };
	my $length_HLtxt = length($columnname_prot_HLratio);
	foreach my $ratio_headers ( @proteins_columnheaders[@pos_header_prot_HLratio] ) {
		my $tmp_exp_label = substr( $ratio_headers, $length_HLtxt );
		push( @labels_prot_experiments, $tmp_exp_label );
	}

	#Remove summary columns (grouping results for all experiments)
	if ( scalar(@labels_prot_experiments) > 1 ) {
		shift(@labels_prot_experiments) if ( $labels_prot_experiments[0] =~ /^[\s]*$/ );
	}

	#print join('*', @labels_prot_experiments);

	my $total_nb_ratio_cases = ( scalar(@labels_prot_experiments) * scalar(@ratio_MQvalue) );

	print $PROTFILTERED2 join( "\t", @proteins_columnheaders[ 0 .. $pos_prot_PEP ] ) ;
    print $PROTDELETED2 join( "\t", @proteins_columnheaders[ 0 .. $pos_prot_PEP ] ) ;
	foreach my $exp (@labels_prot_experiments) {
		foreach my $ratiotype (@ratio_MQvalue) {

			my @ratio_label_headers = ();
			push( @ratio_label_headers, map { $ratiotype . $_ . $exp } @label_MQvalue );

			# Copy it in outputs
			print $PROTFILTERED2 "\t".join( "\t", @ratio_label_headers );
            print $PROTDELETED2 "\t".join( "\t", @ratio_label_headers );

		}
	}
	print $PROTFILTERED2 "\n";
    print $PROTDELETED2 "\n";

  PROTEINSLOOP2:
	while ( $input_line = <$PROTEINSLIST2> ) {

		$input_line =~ s/[\t\n\r]{1,}$//s;    # problem with chomp?
		my @columns = split( /[\t]/, $input_line, -1 );

		my $filtered_line = join( "\t", @columns[ 0 .. $pos_prot_PEP ] ) . "\t";
		my $deleted_line = join( "\t", @columns[ 0 .. $pos_prot_PEP ] ) . "\t" ;
		my $count_ratiosok = 0;

		foreach my $exp (@labels_prot_experiments) {
			foreach my $ratiotype (@ratio_MQvalue) {

				my @ratio_label_headers = ();
				push( @ratio_label_headers, map { $ratiotype . $_ . $exp } @label_MQvalue );
				my ($ratio_count_pos) = @proteins_headers{ ( grep { /Count/ } @ratio_label_headers ) };
				my $ratio_count = $columns[$ratio_count_pos];

				if ( length($ratio_count) && $ratio_count > 1 ) {
					my @all_ratio_pos    = @proteins_headers{@ratio_label_headers};
					my @all_ratio_values = @columns[@all_ratio_pos];
					$filtered_line .= join( "\t", @all_ratio_values ) . "\t";
					$count_ratiosok++;

					$deleted_line .= "\t" x scalar(@ratio_label_headers);
				}
				else {
					$filtered_line .= "\t" x scalar(@ratio_label_headers);

					my @all_ratio_pos    = @proteins_headers{@ratio_label_headers};
					my @all_ratio_values = @columns[@all_ratio_pos];
					$deleted_line .= join( "\t", @all_ratio_values ) . "\t";
				}

			}
		}

		if ( $count_ratiosok > 0 ) {    #&& $count_ratiosok==$total_nb_ratio_cases
			print $PROTFILTERED2 $filtered_line . "\n";
			print $PROTDELETED2 $deleted_line . "\n" if ( $count_ratiosok != $total_nb_ratio_cases );
		}
		else {
			print $PROTDELETED2 $deleted_line . "\n";
		}

	}

	close($PROTEINSLIST2);
	close($PROTFILTERED2);
	close($PROTDELETED2);
