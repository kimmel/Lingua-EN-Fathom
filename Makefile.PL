use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile
(
   'VERSION_FROM'    => 'Fathom.pm',
   'clean'           =>
   {
      'FILES'        => 'blib/* Makefile MANIFEST Lingua-EN-Fathom-*'
   },
   'dist'            =>
   {
      'COMPRESS'     => 'gzip',
      'SUFFIX'       => 'gz'
   },
   'DISTNAME'        => 'Lingua-EN-Fathom',
   
   ( $] >= 5.005 ?
      (
          ABSTRACT => 'text readability and general measurements',
          AUTHOR   => 'Kim Ryan',
      ) : () 
   ),
   
   'NAME'            => 'Lingua::EN::Fathom',
   'PM'              =>
   {
      'Fathom.pm' => '$(INST_LIBDIR)/Fathom.pm',
   },
   'PREREQ_PM'       =>         
   {                            
      'Lingua::EN::Syllable' => 0, 
   }                            
);
