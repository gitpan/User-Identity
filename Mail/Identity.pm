package Mail::Identity;
our $VERSION = 0.03;  # Part of User::Identity
use base 'User::Identity::Collection::Item';

use strict;
use warnings;

use User::Identity;
use Scalar::Util 'weaken';

sub init($)
{   my ($self, $args) = @_;

    $self->SUPER::init($args);
    defined $args->{$_} && ($self->{'MI_'.$_} = delete $args->{$_})
        foreach qw/
comment
domainname
email
location
organization
pgp_key
phrase
signature
username
/;

   $self;
}

sub comment()
{   my $self = shift;
    return $self->{MI_comment} if defined $self->{MI_comment};

    my $user = $self->user     or return undef;
    my $full = $user->fullName or return undef;
    $self->phrase eq $full ? undef : $full;
}

sub domainname()
{   my $self = shift;
    return $self->{MI_domainname}
        if defined $self->{MI_domainname};

    my $email = $self->{MI_email} || '@localhost';
    $email =~ s/.*?\@// ? $email : undef;
}

sub email()
{   my $self = shift;
    return $self->{MI_email} if defined $self->{MI_email};
    $self->username .'@'. $self->domainname;
}

sub location()
{   my $self      = shift;
    my $location  = $self->{MI_location};

    if(! defined $location)
    {   my $user  = $self->user or return;
        my @locs  = $user->collection('locations');
        $location =  @locs ? $locs[0] : undef;
    }
    elsif(! ref $location)
    {   my $user  = $self->user or return;
        $location = $user->find(location => $location);
    }

    $location;
}

sub organization()
{   my $self = shift;

    return $self->{MI_organization} if defined $self->{MI_organization};

    my $location = $self->location or return;
    $location->organization;
}

#pgp_key

sub phrase()
{  my $self = shift;
    return $self->{MI_phrase} if defined $self->{MI_phrase};

    my $user = $self->user     or return undef;
    my $full = $user->fullName or return undef;
    $full;
}

#signature

sub username()
{   my $self = shift;
    return $self->{MI_username} if defined $self->{MI_username};

    if(my $email = $self->{MI_email})
    {   $email =~ s/\@.*$//;   # strip domain part if present
        return $email;
    }

    my $user = $self->user or return;
    $user->nickname;
}

1;

