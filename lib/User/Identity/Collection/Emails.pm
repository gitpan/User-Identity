# Copyrights 2003-2014 by [Mark Overmeer <perl@overmeer.net>].
#  For other contributors see Changes.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 2.01.
package User::Identity::Collection::Emails;
our $VERSION = '0.94';

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

