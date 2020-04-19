#!/usr/bin/env perl

use lib 't/lib';
use Test::Most;
use Local::Schema;

ok my $schema = Local::Schema->connect;
ok my $artist_rs = $schema->resultset('Artist');
ok my $artist = $artist_rs->create({name=>'Foo'});

warn $artist->spork;

done_testing;
