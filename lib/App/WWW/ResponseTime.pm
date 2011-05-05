package App::WWW::ResponseTime;

use strict;
use warnings;
use Carp qw( croak );
use LWP::UserAgent;
use Time::HiRes qw( gettimeofday );
use App::WWW::ResponseTime::Log;
use App::WWW::ResponseTime::Stat;
use Mouse;

our $VERSION = "0.02";

has ua   => (
    is      => "rw",
    isa     => "LWP::UserAgent",
    default => sub { LWP::UserAgent->new( timeout => 30 ) },
);
has stat => (
    is      => "rw",
    isa     => "App::WWW::ResponseTime::Stat",
    default => sub { App::WWW::ResponseTime::Stat->new },
);

no Mouse;
__PACKAGE__->meta->make_immutable;

sub measure {
    my $self = shift;
    my $uri  = shift
        or croak "URI required.";

    my $log = App::WWW::ResponseTime::Log->new
                                         ->start;

    my $res = $self->ua->get( $uri );

    $log->stop( $res->status_line );

    push @{ $self->stat->logs }, $log;

    return $log;
}


1;
__END__

=head1 NAME

App::WWW::ResponseTime - measure a website's response time

=head1 SYNOPSIS

  use App::WWW::ResponseTime;

  my $app = App::WWW::ResponseTime->new;

  local $SIG{INT} {
      say $app->stat;
      exit;
  };

  while ( 1 ) {
      my $log = $app->measure( "http://purasi-bo.me/" );
      sleep 1;
      say $log;
  }

=head1 DESCRIPTION

App::WWW::ResponseTime can make response time statistics.

=head1 AUTHOR

kuniyoshi kouji E<lt>kuniyoshi@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
