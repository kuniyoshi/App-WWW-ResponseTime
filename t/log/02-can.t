use Test::More tests => 1;

my $module  = "App::WWW::ResponseTime::Log";
eval "use $module";
my @methods = qw(
    started_at  ended_at  time_zone  date_format  delimiter  message
    start  stop
    duration  interval
    as_string
);

can_ok( $module, @methods );

