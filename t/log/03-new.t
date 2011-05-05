use Test::More tests => 1;

my $module  = "App::WWW::ResponseTime::Log";
eval "use $module";

new_ok( $module );

