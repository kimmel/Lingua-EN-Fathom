#------------------------------------------------------------------------------
# Test script for Lingua::EN::::Fathom.pm 
#                                            
# Author: Kim Ryan (kimaryan@ozemail.com.au) 
# Date  : 20 January 2000                         
#------------------------------------------------------------------------------

use strict;
use Lingua::EN::Fathom;

# We start with some black magic to print on failure.

BEGIN { print "1..5\n"; }

# Main tests

my $sample =  q{
Returns the number of words in the analysed text file or block. A word must
consist of letters a-z with at least one vowel sound, and optionally an
apostrophe or hyphen. Items such as "&, K108, NSW" are not counted as words.


};

my $text = new Lingua::EN::Fathom;
$text->analyse_block($sample);

print $text->num_chars       == 222 ? "ok 1\n" : "not ok 1\n"; 
print $text->num_words       == 39  ? "ok 2\n" : "not ok 2\n"; 
print $text->num_sentences   == 3   ? "ok 3\n" : "not ok 3\n"; 
print $text->num_text_lines  == 3   ? "ok 4\n" : "not ok 4\n"; 
print $text->num_blank_lines == 4   ? "ok 5\n" : "not ok 5\n"; 



