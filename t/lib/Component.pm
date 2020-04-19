package Component;

use base qw/DBIx::Class/;
use DBIx::Class::MooResultClass;

has foo => (is => 'ro');

1;
