package User::Identity::Collection::Systems;
our $VERSION = 0.04;  # Part of User::Identity
use base 'User::Identity::Collection';

use strict;
use warnings;

use User::Identity::System;

sub new(@)
{   my $class = shift;
    $class->SUPER::new(systems => @_);
}

sub init($)
{   my ($self, $args) = @_;
    $args->{item_type} ||= 'User::Identity::System';

    $self->SUPER::init($args);

    $self;
}

1;

