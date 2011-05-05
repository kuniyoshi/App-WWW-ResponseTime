use Test::More tests => 1;
use App::WWW::ResponseTime::Stat;

my @logs = (
    "2011-05-05T15:31:18.371124 - 0.704353 - foo",
    "2011-05-05T15:31:32.164006 - 0.767376 - foo",
    "2011-05-05T15:31:41.504678 - 0.155390 - foo",
    "2011-05-05T15:31:49.981023 - 0.217296 - foo",
    "2011-05-05T15:31:58.833986 - 0.796129 - foo",
);

my $stat = App::WWW::ResponseTime::Stat->new;
$stat->logs( \@logs );

is( $stat->basics, "min: 0.155390, max: 0.796129, mean: 0.53, median: 0.7, mode: [0.16, 0.22, 0.7, 0.77, 0.8]" );

