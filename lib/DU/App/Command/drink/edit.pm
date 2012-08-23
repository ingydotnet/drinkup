package DU::App::Command::drink::edit;

use 5.16.1;
use Moo;

extends 'DU::App::Command';
use DU::Util 'drink_as_markdown', 'drink_as_data';

sub abstract { 'edit drink' }

sub usage_desc { 'du drink edit $drink' }

sub execute {
   my ($self, $opt, $args) = @_;

   DU::Util::single_item(sub {
      my $data = DU::Util::edit_data(drink_as_data($_[0]));

      $_[0]->update($data);

      print drink_as_markdown($_[0]);
      say 'drink (' . $_[0]->name . ') updated';
   }, 'drink', $args->[0], $self->rs('Drink'));
}

1;

