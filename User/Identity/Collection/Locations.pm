package User::Identity::Collection::Locations;
our $VERSION = 0.02;  # Part of User::Identity
use base 'User::Identity::Collection';

use strict;
use warnings;

use User::Identity::Location;

use Carp qw/croak/;

sub new(@)
{   my $class = shift;
    $class->SUPER::new(locations => @_);
}

sub init($)
{   my ($self, $args) = @_;
    $args->{item_type} ||= 'User::Identity::Location';

    $self->SUPER::init($args);

    $self;
}

1;

