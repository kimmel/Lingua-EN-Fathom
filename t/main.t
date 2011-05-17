#!./perl

#------------------------------------------------------------------------------
# Test script for Lingua::EN::::Fathom.pm
#
# Author      :
# Last update : 2011-05-16
#------------------------------------------------------------------------------

use warnings;
use strict;
use diagnostics;
use Test::More qw( tests 43 );

BEGIN {

  # does it load properly?
  require_ok('Test::More');
  use_ok('Lingua::EN::Fathom');
  require_ok('Lingua::EN::Fathom');
}

#------------------------------------------------------------------------------
sub init_test {
  my $data = shift;

  is( $data->flesch,              0,     'init flesch' );
  is( $data->fog,                 0,     'init fog' );
  is( $data->num_words,           0,     'init num_words' );
  is( $data->num_chars,           0,     'init num_chars' );
  is( $data->num_paragraphs,      0,     'init num_paragraphs' );
  is( $data->{num_syllables},     0,     'init num_syllables' );
  is( $data->num_blank_lines,     0,     'init num_blank_lines' );
  is( $data->num_text_lines,      0,     'init num_text_lines' );
  is( $data->{file_name},         q{},   'init file_name' );
  is( $data->num_sentences,       0,     'init num_sentences' );
  is( $data->kincaid,             0,     'init kincaid' );
  is( $data->{unique_words},      undef, 'init unique_words' );
  is( $data->{num_complex_words}, 0,     'init num_complex_words' );

  return;
}

#------------------------------------------------------------------------------
my $sample = <<'SAMPLE';
Returns the number of words in the analysed text file or block. A word must
consist of letters a-z with at least one vowel sound, and optionally an
apostrophe or hyphen. Items such as "&, K108, NSW" are not counted as words.



SAMPLE

my $sample_report = <<'SAMPLE_REPORT';
Number of characters       : 222
Number of words            : 38
Percent of complex words   : 7.89
Average syllables per word : 1.4474
Number of sentences        : 3
Average words per sentence : 12.6667
Number of text lines       : 3
Number of blank lines      : 4
Number of paragraphs       : 1


READABILITY INDICES

Fog                        : 8.2246
Flesch                     : 71.5310
Flesch-Kincaid             : 6.4289
SAMPLE_REPORT

my $file = Lingua::EN::Fathom->new();
isa_ok( $file, 'Lingua::EN::Fathom' );

# Test empty parameter
$file->analyse_file(q{});
init_test($file);

#use Data::Dumper;
#print Dumper $file;

# Test empty parameter
my $text = Lingua::EN::Fathom->new();
$text->analyse_block(q{});
init_test($text);

# Test a normal paragraph
$text->analyse_block($sample);

is( $text->num_chars, 222, 'run num_chars' );
is( $text->num_words, 38,  'run num_words' );
is( $text->percent_complex_words,
  7.89473684210526, 'run percent_complex_words' );
is( $text->num_sentences,      3,                'run num_sentences' );
is( $text->num_text_lines,     3,                'run num_text_lines' );
is( $text->num_blank_lines,    4,                'run num_blank_lines' );
is( $text->num_paragraphs,     1,                'run num_paragraphs' );
is( $text->syllables_per_word, 1.44736842105263, 'run syllables_per_word' );
is( $text->words_per_sentence, 12.6666666666667, 'run words_per_sentence' );
is( $text->fog,                8.22456140350877, 'run fog' );
is( $text->flesch,             71.5309649122807, 'run flesch' );
is( $text->kincaid,            6.42894736842105, 'run kincaid' );
is( $text->report,             $sample_report,   'run report' );
