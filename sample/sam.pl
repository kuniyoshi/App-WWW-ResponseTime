#!/usr/bin/perl

use 5.10.0;
use utf8;
use strict;
use warnings;
use open ":utf8";
use open ":std";
use FindBin;
use lib "$FindBin::Bin/../lib";
use App::WWW::ResponseTime;

my $app = App::WWW::ResponseTime->new;

local $SIG{INT} = sub {
    say $app->stat;
    exit;
};

while ( 1 ) {
    say $app->measure( "http://purasi-bo.me" );
    sleep 1;
}

exit;

