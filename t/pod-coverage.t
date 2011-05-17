#!perl

use warnings;
use strict;
use Test::More;
use Module::Load::Conditional qw( can_load check_install );

my $m = 'Test::Pod::Coverage';
my $v = '1.04';

if ( check_install( module => $m, version => $v ) ) {
  if ( can_load( modules => { $m => $v, }, verbose => 1 ) ) {
    Test::Pod::Coverage::all_pod_coverage_ok();
  }
}
else {
  plan skip_all => "$m $v required for testing POD coverage";
}
