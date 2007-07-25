# Copyrights 2003,2004,2007 by Mark Overmeer <perl@overmeer.net>.
#  For other contributors see Changes.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 1.02.
package User::Identity::Collection::Systems;
use vars '$VERSION';
$VERSION = '0.92';
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

