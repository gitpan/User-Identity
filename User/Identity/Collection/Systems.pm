package User::Identity::Collection::Systems;
our $VERSION = 0.03;  # Part of User::Identity
use base 'User::Identity::Collection';

use strict;
use warnings;

use Mail::Identity;

sub new(@)
{   my $class = shift;
    $class->SUPER::new(emails => @_);
}

sub init($)
{   my ($self, $args) = @_;
    $args->{item_type} ||= 'User::Identity::System';

    $self->SUPER::init($args);

    $self;
}

1;

