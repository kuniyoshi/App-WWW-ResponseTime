use Test::More tests => 1;
use App::WWW::ResponseTime::Log;

my $log = App::WWW::ResponseTime::Log->new;
$log->start;

isa_ok( $log->started_at, "DateTime" );

