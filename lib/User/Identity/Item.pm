package User::Identity::Item;
use vars '$VERSION';
$VERSION = '0.05';

use strict;
use warnings;

use Scalar::Util qw/weaken/;
use Carp;


sub new(@)
{   my $class = shift;
    return undef unless @_;       # no empty users.

    unshift @_, 'name' if @_ %2;  # odd-length list: starts with nick

    my %args = @_;
    my $self = (bless {}, $class)->init(\%args);

    if(my @missing = keys %args)
    {   local $" = '", "';
        carp "WARNING: Unknown ".(@missing==1? 'option' : 'options' )
           . " \"@missing\" for a $class";
    }

    $self;
}

sub init($)
{   my ($self, $args) = @_;

   unless(defined($self->{UII_name} = delete $args->{name}))
   {   croak "ERROR: Each item requires a name";
   }

   $self->{UII_description} = delete $args->{description};
   $self;
}

#-----------------------------------------


sub name() { shift->{UII_name} }

#-----------------------------------------


sub description() {shift->{UII_description}}

#-----------------------------------------

1;

