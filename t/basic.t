#!/usr/bin/env perl

use lib 't/lib';
use Test::Most;
use Test::DBIx::Class 
  -schema_class => 'Local::Schema',
  qw(:resultsets);

ok my $artist = Artist->create({name=>'Foo'});
ok $artist->spork, 'THERE IS NO SPROK';

done_testing;
