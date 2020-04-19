package DBIx::Class::MooResultClass;

use strict;
use warnings;
use Import::Into;
use Sub::Defer;

sub import {
  base->import::into(1, 'DBIx::Class::Core');
  mro->import::into(1, 'c3');
  Moo->import::into(1);
  my $targ = caller();
  defer_sub "${targ}::FOREIGNBUILDARGS" => sub {    
    my %specs = %{Moo->_constructor_maker_for($targ)->all_attribute_specs||{}};
    my @init_args = grep defined, map +(exists $specs{$_}{init_arg} ? $specs{$_}{init_arg} : $_), sort keys %specs;
    sub {
      my ($class, $args) = @_;
      delete @{$args = { %$args }}{@init_args};
      return $args;
    };
  };
}

1;


