package User::Identity::Collection::Item;
use vars '$VERSION';
$VERSION = '0.06';
use base 'User::Identity::Item';

use strict;
use warnings;

use User::Identity;
use Scalar::Util qw/weaken/;
use Carp         qw/carp croak/;


sub init($)
{  my ($self, $args) = @_;

   if(my $user = delete $args->{user})
   {   $self->user($user);
   }

   $self->SUPER::init($args);
}

#-----------------------------------------


sub user(;$)
{   my $self = shift;
    if(@_)
    {   my $user = $self->{UICI_user} = shift;
        weaken($self->{UICI_user}) if defined $user;
    }

    $self->{UICI_user};
}

#-----------------------------------------

1;

