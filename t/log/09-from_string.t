use Test::More tests => 1;
use App::WWW::ResponseTime::Log;

my $string = "2011-05-05T08:28:26.585535 - 118.415216 - foo";

my $log = App::WWW::ResponseTime::Log->from_string( $string );

is( "$log", $string );

