package User::Identity::Collection;
our $VERSION = 0.02;  # Part of User::Identity

use strict;
use warnings;

use User::Identity;
use Carp;
use Scalar::Util qw/weaken/;
use List::Util   qw/first/;

sub new(@)
{   my $class = shift;
    return undef unless @_;           # no empty users.

    unshift @_, 'name' if @_ %2;  # odd-length list: starts with nick

    (bless {}, $class)->init( {@_} );
}

sub init($)
{   my ($self, $args) = @_;

    defined $args->{$_} && ($self->{'UIC_'.$_} = delete $args->{$_})
        foreach qw/
name
item_type
/;

   if(my $user = delete $args->{user})
   {   $self->user($user);
   }

   if(keys %$args)
   {   local $" = ', ';
       croak "ERROR: Unknown option(s): @{ [keys %$args ] }.";
   }

   unless(defined $self->name)
   {   require Carp;
       croak "ERROR: Each collection requires a name.";
   }

   $self->{UIC_roles} = { };
   my $roles = $args->{roles};
   my @roles = ! defined $roles ? () : ref $roles eq 'ARRAY' ? @$roles : $roles;
   $self->addRole($_) foreach @roles;

   $self;
}

use overload '""' => sub {
   my $self = shift;
   $self->name . ": " . join(", ", sort map {$_->name} $self->roles);
};

use overload '@{}' => sub { [ values %{$_[0]->{UIC_roles}} ] };

sub name() { shift->{UIC_name} }

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
{   my $self = shift;

    return $self->{UIC_roles}{ (shift) }
        unless ref $_[0];

    my $code = shift;

    wantarray
    ? grep  { $code->($_, $self) } $self->roles
    : first { $code->($_, $self) } $self->roles;
}

1;

