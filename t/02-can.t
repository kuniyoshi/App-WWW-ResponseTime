use Test::More tests => 1;

my $module = "App::WWW::ResponseTime";
eval "use $module";
my @methods = qw( ua  stat  measure );

can_ok( $module, @methods );


