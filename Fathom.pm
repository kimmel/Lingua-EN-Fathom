=head1 NAME

Lingua::EN::Fathom - provide readability and general text measurements 

=head1 SYNOPSIS

   use Lingua::EN::Fathom;

   my $text = new Lingua::EN::Fathom; 

	$text->analyse_file("sample.txt");
   
	$text->analyse_block($text_string);
   
   $num_chars       = $text->num_chars;
   $num_words       = $text->num_words;
   $num_sentences   = $text->num_sentences;
   $num_text_lines  = $text->num_text_lines;
   $num_blank_lines = $text->num_blank_lines;
   
   %words = $text->unique_words;
	foreach $word ( sort keys %words )
	{
		print("$words{$word} :$word\n");
	}
   
   $fog     = $text->fog;
   $flesch  = $text->flesch;
   $kincaid = $text->kincaid;
   
	print($text->report);
   

=head1 REQUIRES

Perl, version 5.001 or higher, Lingua::EN::Syllable 


=head1 DESCRIPTION

This module analyses English text in either a string or file. Totals are 
then calculated for the number of characeters, words, sentences, blank
and onon blank (text) lines.

Three common readablity statistics are also derived, the Fog, Flesch and
Kincaid indices. 

All of these properties can ve accessed through individual methods, or by
generatring a text report.

	

=head1 METHODS

=head2 new

The C<new> method creates an instance of an text object This must be called 
before any of the following methods are invoked. Note that the object only 
needs to be created once, and can be reused with new input data.

   my $text = new Lingua::EN::Fathom; 

=head2 analyse_file

The C<analyse_file> method takes as input the name of a text file. Various
text based statistics are calculated for the file. This method and 
C<analyse_block> are prerequisites for all the following methods.


=head2 analyse_block

The C<analyse_block> method takes as input the name of a text file. Various
text based statistics are calculated for the file. This method and 
C<analyse_file> are prerequisites for all the following methods.


=head2 num_chars

Returns the number of characters in the analysed text file or block. This 
includes characters such as spaces, and punctuation marks.

=head2 num_words

Returns the number of words in the analysed text file or block. A word must
consist of letters a-z with at least one vowel sound, and optionally an
apostrophe or hyphen. Items such as "&, K108, NSW"	are not counted as words.


=head2 num_sentences

Returns the number of sentences in the analysed text file or block. A sentence
is any group of words and non words terminated with a single full stop. Spaces
may occur before and after the full stop. 


=head2 num_text_lines

Returns the number of lines containing some text in the analysed text file
or block.

=head2 num_blank_lines

Returns the number of lines NOT containing any text in the analysed text file 
or block.
   
=head2 fog

Returns the Fog index for the analysed text file or block.

The Fog index, developed by Robert Gunning, is a well known and simple
formula for measuring readability. The index indicates the number of years
of formal education a reader of average intellegence would need to read the
text once and understand that piece of writing with its word sentence workload.

	18 unreadable
   14 difficult
   12 ideal
   10 acceptable
    8 childish


=head2 flesch

Returns the Flesch reading ease score for the analysed text file or block.

This score rates text on a 100 point scale. The higher the score, the easier 
it is to understand the text. A score of 60 to 70 is considered to be optimal.


=head2 kincaid

Returns the Flesch-Kincaid grade level score for the analysed text 
file or block.

This score rates text on  U.S. grade school level. So a score of 8.0 means
that the document can be understood by an eighth grader. A score of 7.0 to 
8.0 is considered to be optimal.



=head2 unique_words

Returns a hash of unique words. The word itself (in lower case)is held in 
the hash key while the number of occurrences is held in the hash value.



=head1 LIMITATIONS


=head1 SEE ALSO

B::Fathom


=head1 POSSIBLE EXTENSIONS

	Analyse many files at once
	Analyse HTML and other formats
   Count paragraphs
   Allow user control over what strictly defines a word
   Provide a density measure of white space to characters 


=head1 BUGS


=head1 CHANGES

0.01 23 Jan 2000: First Release

                  
=head1 COPYRIGHT

Copyright (c) 2000 Kim Ryan. All rights reserved.
This program is free software; you can redistribute it 
and/or modify it under the terms of the Perl Artistic License
(see http://www.perl.com/perl/misc/Artistic.html).


=head1 AUTHOR

Fathom was written by Kim Ryan <kimaryan@ozemail.com.au> in 2000.


=cut

#------------------------------------------------------------------------------

package Lingua::EN::Fathom;

use Lingua::EN::Syllable;
use strict;

use Exporter;
use vars qw (@ISA @EXPORT_OK $VERSION);

$VERSION   = '1.00';
@ISA       = qw(Exporter);

#------------------------------------------------------------------------------
sub new
{
   my $class = shift;

   my $text = {};
   bless($text,$class);
   return($text);
}
#------------------------------------------------------------------------------
sub analyse_file
{
   my $text = shift;
   my ($file_name) = @_;
   
   $text = &_initialize($text);
   $text->{file_name} = $file_name;
   
   # Only analyse non-empty text files
   unless ( -T $file_name and -s $file_name )
   {
	   return($text);
   }
   
	open(IN_FH,"<$file_name");
   
	while ( <IN_FH> )
   {
   	my $one_line = $_;
      if ( $one_line =~ /\w/ )
      {
      	chomp($one_line);
		   $text = &_analyse_line($text,$one_line);
	      $text->{num_text_lines}++;
      }
      else # empty or blank line
      {
	      $text->{num_blank_lines}++;
      }
	}
   close(IN_FH);
   $text->_calculate_readability;
   
   return($text);
}
#------------------------------------------------------------------------------
sub analyse_block
{
   my $text = shift;
   my ($block) = @_;
   
   $text = &_initialize($text);
   
   unless ( $block )
   {
	   return($text);
   }
   
   # by setting limit to -1, we prevent split from stripping 
   # trailing line terminators
   my @all_lines = split(/\n/,$block,-1);
   my $one_line;
   foreach $one_line ( @all_lines )
   {
      if ( $one_line =~ /\w/ )
      {
		   $text = &_analyse_line($text,$one_line);
	      $text->{num_text_lines}++;
      }
      else # empty or blank line
      {
	      $text->{num_blank_lines}++;
      }
	}
   
   $text->_calculate_readability;
   return($text);
}
#------------------------------------------------------------------------------
sub num_chars
{
   my $text = shift;
   return($text->{num_chars});
}
#------------------------------------------------------------------------------
sub num_words
{
   my $text = shift;
   return($text->{num_words});
}
#------------------------------------------------------------------------------
sub num_sentences
{
   my $text = shift;
   return($text->{num_sentences});
}
#------------------------------------------------------------------------------
sub num_text_lines
{
   my $text = shift;
   return($text->{num_text_lines});
}
#------------------------------------------------------------------------------
sub num_blank_lines
{
   my $text = shift;
   return($text->{num_blank_lines});
}
#------------------------------------------------------------------------------
sub fog
{
   my $text = shift;
   return($text->{fog});
}
#------------------------------------------------------------------------------
sub flesch
{
   my $text = shift;
   return($text->{flesch});
}
#------------------------------------------------------------------------------
sub kincaid
{
   my $text = shift;
   return($text->{kincaid});
}
#------------------------------------------------------------------------------
sub unique_words
{
   my $text = shift;
   # return annonymous hash of unique words
   if ( $text->{unique_words} )
   {
	   return( %{ $text->{unique_words} } );
   }
   else
   {
   	return(undef);
   }
}
#------------------------------------------------------------------------------
# Provide a formatted text report of all statistics for a text object.
# Return report as a string.

sub report
{
   my $text = shift;
   
   my $report = '';
   
   if ( $text->{file_name} )
   {
	$report .= sprintf("File name              : %s\n",$text->{file_name} );
   }
      
   $report .= sprintf("Number of characters   : %d\n",$text->num_chars);
   $report .= sprintf("Number of words        : %d\n",$text->num_words);
   $report .= sprintf("Number of sentences    : %d\n",$text->num_sentences);
   $report .= sprintf("Number of text lines   : %d\n",$text->num_text_lines);
   $report .= sprintf("Number of blank lines  : %d\n",$text->num_blank_lines);
   
   $report .= "\n\nREADABILITY INDICES\n\n";
   $report .= sprintf("Fog                    : %-5.2f\n",$text->fog);
   $report .= sprintf("Flesch                 : %-5.2f\n",$text->flesch);
   $report .= sprintf("Flesch-Kincaid         : %-5.2f\n",$text->kincaid);
   
   return($report);
}

#------------------------------------------------------------------------------
# PRIVATE METHODS
#------------------------------------------------------------------------------
sub _initialize
{
   my $text = shift;
   
   $text->{num_chars} = 0;
   $text->{num_syllables} = 0;
   $text->{num_words} = 0;
   $text->{num_complex_words} = 0;
   $text->{num_text_lines} = 0;
   $text->{num_blank_lines} = 0;
   $text->{num_sentences} = 0;
   $text->{unique_words} = ();
   $text->{file_name} = '';
   
   
   return($text);
}
#------------------------------------------------------------------------------
sub _analyse_line
{
   my $text = shift;
	my ($one_line) = @_;

    $text->{num_chars} += length($one_line);
      
   # Word found, such as: twice, BOTH, I'll, non-plussed ..
   # Ignore words like K12, &, X.Y.Z ...
   while ( $one_line =~ /\b([A-Za-z][-'A-Za-z]*)\b/g ) 
   {
   	my $one_word = $1;
      
   	# Try to filter out acronyms and  abbreviations by accepting words with a
      # vowel sound, won't work for GPO etc. 
      next unless $one_word =~ /[aeiouy]/i;
      
      # add test for validity of hypenated word
      
		# word frequency count
		$text->{unique_words}{lc($one_word)}++;
      
      $text->{num_words}++;
      
      # Use subroutine from Lingua::EN::Syllable
      my $num_syllables = &syllable($one_word);
      $text->{num_syllables} += $num_syllables;
      
      # Required for Fog index, non hyphenated word of 3 or more syllables 
      # Should add check for proper names in here as well
      if ( $num_syllables > 2 and $one_word !~ /-/ )
      {
      	$text->{num_complex_words}++;
      }
	}
   
   # Search for full stop to end a sentence. 
   while ( $one_line =~ /\b\s*\.\s*\b/g ) { $text->{num_sentences}++ }
   $one_line =~ /\b\s*\.\s*$/g and $text->{num_sentences}++;
   
   return($text);
}
#------------------------------------------------------------------------------
sub _calculate_readability
{
   my $text = shift;
   
   if ( $text->{num_sentences} and  $text->{num_words} )
   {
   
	   $text->{words_per_sentence} = $text->{num_words} / $text->{num_sentences};
	   $text->{syllables_per_word} = $text->{num_syllables} / $text->{num_words};
	   
	   $text->{fog} = ( $text->{words_per_sentence} +  $text->{num_complex_words} ) * 0.4;
	   
		$text->{flesch} =  206.835 - (1.015 * $text->{words_per_sentence}) -
	   	(84.6 * $text->{syllables_per_word});
	      
		$text->{kincaid} =  (11.8 * $text->{syllables_per_word}) + 
	   	(0.39 * $text->{words_per_sentence}) - 15.59;
   }
   else
   {
	   $text->{words_per_sentence} = 0;
	   $text->{syllables_per_word} = 0;
	   $text->{fog} = 0;
		$text->{flesch} = 0;
		$text->{kincaid} = 0;
   }
}
#------------------------------------------------------------------------------
return(1);
