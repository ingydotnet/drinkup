package DU::App::Command::maint::export;

use 5.14.1;
use warnings;

use DU::App -command;
use DU::Util 'single_item';

sub abstract { '' }

sub usage_desc { '' }

sub execute {
   my ($self, $opt, $args) = @_;

   use lib 't/lib';
   require A;
   my $s = $self->app->app->schema;

   A->_deploy_schema($s);
   A->_populate_schema($s);

   say 'done';
}

1;

