use Test::More tests => 1;
use DateTime;
use App::WWW::ResponseTime::Log;

my $log = App::WWW::ResponseTime::Log->new;

$log->started_at(
    DateTime->from_epoch( epoch => "1304551706.585535049", time_zone => "Asia/Tokyo" ),
);
$log->ended_at(
    DateTime->from_epoch( epoch => "1304551825.751000000", time_zone => "Asia/Tokyo" ),
);
$log->message( "foo" );

is( "$log", "2011-05-05T08:28:26.585535 - 119.165465 - foo" );

