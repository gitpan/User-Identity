package User::Identity::Collection;
our $VERSION = 0.03;  # Part of User::Identity
use base 'User::Identity::Item';

use strict;
use warnings;

use User::Identity;
use Carp;
use Scalar::Util qw/weaken/;
use List::Util   qw/first/;

sub init($)
{   my ($self, $args) = @_;

    defined $args->{$_} && ($self->{'UIC_'.$_} = delete $args->{$_})
        foreach qw/
item_type
/;

   $self->SUPER::init($args);

   if(my $user = delete $args->{user})
   {   $self->user($user);
   }

   $self->{UIC_roles} = { };
   my $roles = $args->{roles};

   my @roles
    = ! defined $roles      ? ()
    : ref $roles eq 'ARRAY' ? @$roles
    :                         $roles;

   $self->addRole($_) foreach @roles;

   $self;
}

use overload '""' => sub {
   my $self = shift;
   $self->name . ": " . join(", ", sort map {$_->name} $self->roles);
};

use overload '@{}' => sub { [ shift->roles ] };

sub roles() { values %{shift->{UIC_roles}} }

sub addRole(@)
{   my $self = shift;

    my $role;
    my $maintains = $self->{UIC_item_type};
    if(ref $_[0] && ref $_[0] ne 'ARRAY')
    {   $role = shift;
        croak "ERROR: Wrong type of role for ".ref($self)
            . ": requires a $maintains but got a ". ref($role)
           unless $role->isa($maintains);
    }
    else
    {   $role = $maintains->new(ref $_[0] ? @{$_[0]} :  @_);
        croak "ERROR: Cannot create a $maintains to add this to my collection."
            unless defined $role;
    }

    $role->user($self->user);
    $self->{UIC_roles}{$role->name} = $role;
    $role;
}

sub user(;$)
{   my $self = shift;

    if(@_)
    {   my $user = shift;
        $self->{UIC_user} = $user;

        weaken($self->{UIC_user}) if defined $user;
        $_->user($user) foreach $self->roles;
    }

    $self->{UIC_user};
}

sub find($)
{   my ($self, $select) = @_;

      !defined $select ? ($self->roles)[0]
    : !ref $select     ? $self->{UIC_roles}{$select}
    : wantarray        ? grep ({ $select->($_, $self) } $self->roles)
    :                    first { $select->($_, $self) } $self->roles;
}

1;

