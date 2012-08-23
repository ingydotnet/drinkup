package DU::App::Command::drink::ls;

use 5.16.1;
use Moo;

extends 'DU::App::Command';

sub abstract { 'list drinks' }

sub usage_desc { 'du drink ls' }

sub opt_spec {
   [ 'some_ingredients|s',  'only drinks I can at least partially make' ],
   [ 'no_ingredients|n',  'only drinks I cannot make at all' ],
   [ 'all_ingredients|a',  'only drinks I can make' ],
   [ 'nearly_all_ingredients|e=i',  'drinks I can nearly make' ],
}

sub execute {
   my ($self, $opt, $args) = @_;


   my $rs = $self->rs('Drink');
   my $user = $self->rs('User')->search({
      name => 'frew',
   })->single;

   $rs = $rs->some($user) if $opt->some_ingredients;
   $rs = $rs->none($user) if $opt->no_ingredients;
   $rs = $rs->every($user) if $opt->all_ingredients;
   $rs = $rs->nearly($user, $opt->nearly_all_ingredients ) if $opt->nearly_all_ingredients;

   say '* ' . $_->name for $rs->all
}

1;

