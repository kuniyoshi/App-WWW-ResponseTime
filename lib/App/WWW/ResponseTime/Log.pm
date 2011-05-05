package App::WWW::ResponseTime::Log;

use strict;
use warnings;
use Carp qw( croak );
use List::MoreUtils qw( zip );
use Time::HiRes ( );
use Time::Seconds qw( ONE_MINUTE );
use DateTime;
use DateTime::Format::Strptime;
use overload ( q{""} => sub { shift->as_string }, fallback => 1 );
use Mouse;

our $VERSION     = "0.01";
our $TIME_ZONE   = "Asia/Tokyo";
our $DATE_FORMAT = q{%FT%T.%6N};
our $DELIMITER   = " - ";

has started_at  => ( is => "rw", isa => "DateTime" );
has ended_at    => ( is => "rw", isa => "DateTime" );
has time_zone   => ( is => "rw", isa => "Str", default => sub { $TIME_ZONE } );
has date_format => ( is => "rw", isa => "Str", default => sub { $DATE_FORMAT } );
has delimiter   => ( is => "rw", isa => "Str", default => sub { $DELIMITER } );
has message     => ( is => "rw", isa => "Str", default => q{} );

no Mouse;
__PACKAGE__->meta->make_immutable;

sub from_string {
    my $class  = shift;
    my $string = shift
        or croak "String required.";

    my %log = zip @{ [ qw( start took message ) ] }, @{ [ split $DELIMITER, $string ] };

    my $parser = DateTime::Format::Strptime->new(
        pattern   => $DATE_FORMAT,
        time_zone => $TIME_ZONE,
    );

    my $started_at = $parser->parse_datetime( $log{start} );
    my $ended_at   = do {
        my( $seconds, $microseconds ) = split m{[.]}, $log{took};
        $microseconds =~ s{\A (\d{6}) .* }{$1}msx;
        my $nanoseconds = $microseconds . 0 x ( 9 - length $microseconds );
        $started_at->clone->add(
            seconds     => $seconds,
            nanoseconds => $nanoseconds,
        );
    };

    my $log = $class->new;
    $log->started_at( $started_at );
    $log->ended_at( $ended_at );
    $log->message( $log{message} );

    return $log;
}

sub start {
    my $self = shift;

    $self->started_at(
        DateTime->from_epoch(
            epoch     => Time::HiRes::time,
            time_zone => $self->time_zone,
        ),
    );

    if ( @_ ) {
        $self->message( shift );
    }

    return $self;
}

sub stop {
    my $self = shift;

    $self->ended_at(
        DateTime->from_epoch(
            epoch     => Time::HiRes::time,
            time_zone => $self->time_zone,
        ),
    );

    if ( @_ ) {
        $self->message( shift );
    }

    return $self;
}

sub duration {
    my $self = shift;
    return $self->ended_at - $self->started_at;
}

sub interval {
    my $self     = shift;
    my $duration = $self->duration;

    my $interval = $duration->minutes * ONE_MINUTE
        + $duration->seconds
        + $duration->nanoseconds / 1_000_000_000;

    return sprintf "%.6f", $interval;
}

sub as_string {
    my $self = shift;

    return join(
        $self->delimiter,
        $self->started_at->strftime( $self->date_format ),
        $self->interval,
        $self->message,
    );
}

1;
__END__

=head1 NAME

App::WWW::ResponseTime::Log - log class for response time

=head1 SYNOPSIS

  use App::WWW::ResponseTime::Log;

  my $log = App::WWW::ResponseTime::Log->new
                                       ->start( "foo" );

  # do something;

  $log->stop;

  say $log;

=head1 DESCRIPTION

App::WWW::ResponseTime::Log is just a log class for responce time.

This does B<not> support long interval which overs one hour.

=head1 AUTHOR

kuniyoshi kouji E<lt>kuniyoshi@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
