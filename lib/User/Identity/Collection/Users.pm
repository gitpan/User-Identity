package User::Identity::Collection::Users;
use vars '$VERSION';
$VERSION = '0.90';
use base 'User::Identity::Collection';

use strict;
use warnings;

use User::Identity;


sub new(@)
{   my $class = shift;
    $class->SUPER::new(systems => @_);
}

sub init($)
{   my ($self, $args) = @_;
    $args->{item_type} ||= 'User::Identity';

    $self->SUPER::init($args);

    $self;
}

sub type() { 'people' }

1;

