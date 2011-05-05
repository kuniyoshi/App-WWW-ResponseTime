use Test::More tests => 1;

my $module = "App::WWW::ResponseTime";
eval "use $module";

new_ok( $module );

