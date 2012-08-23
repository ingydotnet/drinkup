#!/usr/bin/env perl

use 5.16.1;
use warnings;

use Test::More;
use App::Cmd::Tester;
use File::Temp 'tempfile';

use lib 't/lib';

use A 'stdout_is';

my $app = A->app;

local $ENV{PATH} = 't/editors:' . $ENV{PATH};

my $app1 = DU::App->new({
   connect_info => {
      dsn => 'dbi:SQLite::memory:',
      on_connect_do => 'PRAGMA foreign_keys = ON',
   },
});
my $app2 = DU::App->new({
   connect_info => {
      dsn => 'dbi:SQLite::memory:',
      on_connect_do => 'PRAGMA foreign_keys = ON',
   },
});

subtest 'install' => sub {
   my $result = test_app($app1 => [qw(maint install),]);
   stdout_is($result, [ 'done' ]);
   is($app1->schema->resultset('Drink')->count, 3, 'drinks correctly seeded');
};

subtest 'install --no-seeding' => sub {
   my $result = test_app($app2 => [qw(maint install --no-seeding),]);
   stdout_is($result, [ 'done' ]);
   is($app2->schema->resultset('Drink')->count, 0, 'drinks correctly unseeded');

   $app2->schema->resultset('Unit')->populate([
      [qw(name gills)],
      [ounce      => 1 / 4         ] ,
      [tablespoon => 1 / 4 / 2     ] ,
      [teaspoon   => 1 / 4 / 2 / 3 ] ,
      [dash       => undef         ] ,
   ]);

};

my (undef, $filename) = tempfile(OPEN => 0);
subtest 'export' => sub {
   ok(!-f 'test-export.tar.xz', 'no export yet');
   my $result = test_app($app1 => [qw(maint export), $filename]);
   stdout_is($result, [ 'done' ]);
   ok(-f "$filename.tar.xz", 'export created');
};
subtest 'import' => sub {
   my $result = test_app($app2 => [qw(maint import), $filename]);
   stdout_is($result, [ 'done' ]);
   unlink "$filename.tar.xz";
};

done_testing;

