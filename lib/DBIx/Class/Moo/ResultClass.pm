package DBIx::Class::Moo::ResultClass;

our $VERSION = '0.001';

use strict;
use warnings;
use Import::Into;
use Sub::Defer;

sub import {
 mro->import::into(1, 'c3');
  Moo->import::into(1);
  my $targ = caller();
  $targ->can('extends')->('DBIx::Class::Core') unless $targ->isa('DBIx::Class');
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

=head1 NAME

DBIx::Class::Moo::ResultClass - Moo-ify DBIC Resultclasses

=head1 SYNOPSIS

    package Schema::Result::Artist;

    use DBIx::Class::Moo::ResultClass;

    extends 'Schema::Result';
    with 'Component';

    has spork => (is => 'ro', default => sub { 'THERE IS NO SPORK' });

    __PACKAGE__->table('artist');

    __PACKAGE__->add_columns(
      artist_id => {
        data_type => 'integer',
        is_auto_increment => 1,
      },
      name => {
        data_type => 'varchar',
        size => '96',
      });

    __PACKAGE__->set_primary_key('artist_id');

    my $artist = $schema->resultset('Artist')
      ->create({name=>'Foo');

    warn $artist->spork; # 'THERE IS NO SPORK'

    my $another = $schema->resultset('Artist')
      ->create({name=>'Foo', spork=>'foo');

    warn $artist->spork; # 'foo'

=head1 DESCRIPTION

B<Note>: Warning, Early Access module.  This is pretty straightforward but we've not used it
extensively so its possible some corner cases exist. Test cases / docs welcomed.

Use L<Moo> with L<DBIx::Class>.  Its not immediately obvious how to do this since L<DBIx::Class>
since you need to fuss with Moo and 'FOREIGNBUILDARGS' to get it working correctly.  So we did
the lifting for you.

You can use this directly on you result classes and/or on a base resultclass.  You can also use
it to consume Moo roles directly:

    package Component;

    use Moo::Role;

    has foo => (is => 'rw');

    package Schema::Result::Artist;

    use DBIx::Class::Moo::ResultClass;

    extends 'Schema::Result';
    with 'Component';

    ...

And it should just do the right thing.

This doesn't work yet on Resultset classes (another time / test cases welcomed).

=head1 AUTHOR
 
John Napiorkowski L<email:jjnapiork@cpan.org>
mst

=head1 SEE ALSO
 
L<DBIx::Class>, L<Moo>
    
=head1 COPYRIGHT & LICENSE
 
Copyright 2020, John Napiorkowski L<email:jjnapiork@cpan.org>
 
This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut



