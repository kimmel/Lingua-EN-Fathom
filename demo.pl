#! /usr/local/bin/perl
# Demo script for Lingua::EN::Fathom.pm

use Lingua::EN::Fathom;

my $sample =  
q{Returns the number of words in the analysed text file or block. A word must
consist of letters a-z with at least one vowel sound, and optionally an
apostrophe or hyphen. Items such as "&, K108, NSW" are not counted as words.
};

my $text = new Lingua::EN::Fathom;
$text->analyse_block($sample);

$num_sentences = $text->num_sentences; 

print($text->report,"\n");

%uniq_words = $text->unique_words;
foreach $word ( sort keys  uniq_words )
{
	# print occurences of each unique word, followed by the word itself
	print("$uniq_words{$word} :$word\n");
}









#------------------------------------------------------------------------------
