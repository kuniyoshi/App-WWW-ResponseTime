use Test::More tests => 1;

my $module  = "App::WWW::ResponseTime::Stat";
eval "use $module";
my @methods = qw(
    as_string
);

can_ok( $module, @methods );

