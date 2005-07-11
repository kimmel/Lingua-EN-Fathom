use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile
(
   'NAME'         => 'Lingua::EN::Fathom',
   'VERSION_FROM' => 'lib/Lingua/EN/Fathom.pm',
   'ABSTRACT'     => 'Measure readability of English text',
   'AUTHOR'       => 'Kim Ryan <kimryan at cpan org>',
   'PREREQ_PM'    =>  { 'Lingua::EN::Syllable' => 0 }                            
);
