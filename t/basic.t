#!/usr/bin/env perl

use lib 't/lib';
use Test::Most;
use Test::DBIx::Class 
  -schema_class => 'Schema',
  qw(:resultsets);

ok my $artist = Artist->create({name=>'Foo', foo=>'aaa'});
ok $artist->spork, 'THERE IS NO SPROK';
ok $artist->foo, 'aaa';
ok $artist->foo('ddd');
ok $artist->foo, 'dddd';

done_testing;
