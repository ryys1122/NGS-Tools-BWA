package NGS::Tools::BWA::Roles::SplitFastq;
use Moose::Role;
use MooseX::Params::Validate;

use strict;
use warnings FATAL => 'all';
use namespace::autoclean;
use autodie;
use File::Basename;
use Data::UUID;

=head1 NAME

NGS::Tools::BWA::Roles::SplitFastq

=head1 SYNOPSIS

A Perl role for splitting FASTQ files for parallelized alignment.

=head1 ATTRIBUTES AND DELEGATES

=head1 SUBROUTINES/METHODS

=head2 $obj->split_fastq()

A method for splitting a FASTQ file into multiple FASTQ files.

=head3 Arguments:

=over 2

=item * fastq: FASTQ file to be split

=item * number_of_reads: an integer value representing number of reads per split file (default: 10,000,000)

=item * prefix: a string to be used as the prefix for the split files

=item * numeric_suffix: use numeric values for split files otherwise use alpha characters (default: y)

=item * is_gzipped: flag to identify whether the files are in gzip format

=item * split: the name of the program to use for splitting.  For Mac OS X use gsplit.

=item * zcat: the name of the program to use for outputting the gzip file.  For Mac OS X use gzcat.

=item * output_directory: the path to the output directory to store the split FASTQ files.

=back

=head3 Return Values:

=over 2

=item A hash reference containing:

=item * cmd: command to execute or submit to cluster

=item * output: string containing alignment prefix

=back

=cut

sub split_fastq {
	my $self = shift;
	my %args = validated_hash(
		\@_,
		fastq => {
			isa         => 'Str',
			required    => 1
			},
		number_of_reads => {
			isa			=> 'Int',
			required	=> 0,
			default		=> 10000000
			},
		prefix => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		numeric_suffix => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'y'
			},
		is_gzipped => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'false'
			},
		split => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'split'
			},
		zcat => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'zcat'
			},
		output_directory => {
			isa			=> 'Str',
			required	=> 0,
			default		=> '.'
			}
		);

	# check to see if output directory exists, if it does not then create it
	if (! -d )

	my $prefix;
	if ($args{'prefix'} eq '') {
		$prefix = basename($args{'fastq'}) . '.';
		}
	else {
		$prefix = $args{'prefix'};
		}

	# since a FASTQ file has 4 lines representing a single read, we multiply the number
	# of reads desired by 4
	my $number_of_reads = $args{'number_of_reads'} * 4;
	my $options = join(' ',
		'-l', $number_of_reads
		);
	if ($args{'numeric_suffix'} eq 'y') {
		$options = join(' ',
			$options,
			'-d'
			);
		}

	my $cmd;
	if ($args{'is_gzipped'} eq 'true') {
		$prefix =~ s/\.gz//;
		$cmd = join(' ',
			$args{'zcat'},
			$args{'fastq'},
			'|',
			$args{'split'},
			$options,
			'-',
			$prefix
			);
		}
	else {
		$cmd = join(' ',
			$args{'split'},
			$options,
			$args{'fastq'},
			$prefix
			);
		}

	my %return_values = (
		output => $prefix,
		cmd => $cmd
		);

	return(\%return_values);
	}

=head2 $obj->split_paired_end_fastq_files()

Split a set of paired end read FATSQ files.  This will assume that both read pair FASTQ files have
been generated correctly and that the read IDs correspond between files.

=head3 Arguments:

=over 2

=item * fastq1: full path to the FASTQ file for read 1

=item * fastq2: full path to the FASTQ file for read 2

=item * number_of_reads: an integer value representing number of reads per split file (default: 10,000,000)

=item * prefix: a string to be used as the prefix for the split files

=item * numeric_suffix: use numeric values for split files otherwise use alpha characters (default: y)

=item * is_gzipped: flag to identify whether the files are in gzip format

=item * split: the name of the program to use for splitting.  For Mac OS X use gsplit.

=item * zcat: the name of the program to use for outputting the gzip file.  For Mac OS X use gzcat.

=back

=head3 Return Value:

This method returns an array reference containing hash references for pairs of read1 and read2 FASTQ files.

=cut

sub split_paired_end_fastq_files {
	my $self = shift;
	my %args = validated_hash(
		\@_,
		fastq1 => {
			isa         => 'Str',
			required    => 1
			},
		fastq2 => {
			isa			=> 'Str',
			required	=> 1
			}
		number_of_reads => {
			isa			=> 'Int',
			required	=> 0,
			default		=> 10000000
			},
		prefix => {
			isa			=> 'Str',
			required	=> 0,
			default		=> ''
			},
		numeric_suffix => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'y'
			},
		is_gzipped => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'false'
			},
		split => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'split'
			},
		zcat => {
			isa			=> 'Str',
			required	=> 0,
			default		=> 'zcat'
			}
		);

	# check if the FASTQ files are gzip files
	my $read1_gzip = 'false';
	my $read2_gzip = 'false';
	if ($args{'fastq1'} =~ m/\.gz$/) {
		$read1_gzip = 'true';
		}

	# split the FASTQ file into a set number of reads per file

	if ($args{'fastq2'} =~ m/\.gz$/) {
		$read2_gzip = 'true';
		}


	my %return_values = (

		);

	return(\%return_values);
	}

=head1 AUTHOR

Richard de Borja, C<< <richard.deborja at sickkids.ca> >>

=head1 ACKNOWLEDGEMENT

Dr. Adam Shlien, PI -- The Hospital for Sick Children

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-test at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=test-test>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NGS::Tools::BWA::Roles::SplitFastq

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=test-test>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/test-test>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/test-test>

=item * Search CPAN

L<http://search.cpan.org/dist/test-test/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Richard de Borja.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

no Moose::Role;

1; # End of NGS::Tools::BWA::Roles::SplitFastq
