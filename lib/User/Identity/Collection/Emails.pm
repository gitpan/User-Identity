package User::Identity::Collection::Emails;
use vars '$VERSION';
$VERSION = '0.90';
use base 'User::Identity::Collection';

use strict;
use warnings;

use Mail::Identity;


sub new(@)
{   my $class = shift;
    $class->SUPER::new(name => 'emails', @_);
}

sub init($)
{   my ($self, $args) = @_;
    $args->{item_type} ||= 'Mail::Identity';

    $self->SUPER::init($args);
}

sub type() { 'mailgroup' }

1;

