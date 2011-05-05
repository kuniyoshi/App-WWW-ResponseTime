use Test::More tests => 2;
use Time::HiRes qw( time );
use App::WWW::ResponseTime::Log;

my $log = App::WWW::ResponseTime::Log->new;

$log->started_at( DateTime->from_epoch( epoch => time, time_zone => "Asia/Tokyo" ) );
$log->ended_at( DateTime->from_epoch( epoch => time + rand, time_zone => "Asia/Tokyo" ) );

my $interval = $log->duration;

isa_ok( $interval, "DateTime::Duration" );

is( $interval->seconds, 0 );

