#!./perl

use warnings;
use strict;
use diagnostics;
use Test::More;
use Module::Load::Conditional qw( can_load check_install );

my $m = 'Test::Pod';
my $v = '1.14';

if ( check_install( module => $m, version => $v ) ) {
  if ( can_load( modules => { $m => $v, }, verbose => 1 ) ) {
    Test::Pod::all_pod_files_ok();
  }
}
else {
  plan skip_all => "$m $v required for testing POD";
}
