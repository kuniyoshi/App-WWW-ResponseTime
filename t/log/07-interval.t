use Test::More tests => 200;
use Time::HiRes qw( time );
use App::WWW::ResponseTime::Log;

my $log    = App::WWW::ResponseTime::Log->new;
my $margin = 0.000001;
my @cases  = map { [ time, substr rand, 0, 8 ] } 1 .. 100;

foreach my $case_ref ( @cases ) {
    my( $time, $wish ) = @{ $case_ref };

    $log->started_at(
        DateTime->from_epoch( epoch => $time, time_zone => "Asia/Tokyo" ),
    );
    $log->ended_at(
        DateTime->from_epoch( epoch => $time + $wish, time_zone => "Asia/Tokyo" ),
    );
    my $got = $log->interval;

    cmp_ok( $got, ">=", $wish - $margin );
    cmp_ok( $got, "<=", $wish + $margin );
}


