package User::Identity::Collection::Systems;
use vars '$VERSION';
$VERSION = '0.90';
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

sub type() { 'network' }

1;

