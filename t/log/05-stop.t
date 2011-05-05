use Test::More tests => 1;
use App::WWW::ResponseTime::Log;

my $log = App::WWW::ResponseTime::Log->new;
$log->stop;

isa_ok( $log->ended_at, "DateTime" );

