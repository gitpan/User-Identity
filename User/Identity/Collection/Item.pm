package User::Identity::Collection::Item;
our $VERSION = 0.02;  # Part of User::Identity

use strict;
use warnings;

use User::Identity;
use Scalar::Util qw/weaken/;
use Carp         qw/carp croak/;

sub new(@)
{   my $class = shift;
    return undef unless @_;       # no empty users.

    unshift @_, 'name' if @_ %2;  # odd-length list: starts with nick

    my %args = @_;
    my $self = (bless {}, $class)->init(\%args);

    if(my @missing = keys %args)
    {   local $" = ', ';
        carp "WARNING: Unknown ".(@missing==1 ? 'option' : 'options')." @missing";
    }

    $self;
}

sub init($)
{   my ($self, $args) = @_;

   unless($self->{UICI_name} = delete $args->{name})
   {   croak "ERROR: Each collectable item requires a name.";
   }

   if(my $user = delete $args->{user})
   {   $self->user($user);
   }

   $self;
}

sub name()
{   my $self = shift;
    $self->{UICI_name} || $self->{UICI_organization};
}

sub user(;$)
{   my $self = shift;
    if(@_)
    {   my $user = $self->{UICI_user} = shift;
        weaken($self->{UICI_user}) if defined $user;
    }

    $self->{UICI_user};
}

1;

