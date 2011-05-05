package App::WWW::ResponseTime::Stat;

use strict;
use warnings;
use Carp qw( croak );
use List::Util qw( max min );
use overload ( q{""} => sub { shift->as_string }, fallback => 1 );
use Statistics::Basic qw( vector mean median mode );
use App::WWW::ResponseTime::Log;
use Mouse;

our $VERSION = "0.01";

has logs          => (
    is      => "rw",
    isa     => "ArrayRef[Str]",
    default => sub { [ ] },
);
has is_parsed     => (
    is      => "rw",
    isa     => "Bool",
    default => 0,
);
has parsed_min   => (
    is      => "rw",
    isa     => "Num",
    default => 0,
);
has parsed_max   => (
    is      => "rw",
    isa     => "Num",
    default => 0,
);
has parsed_mean   => (
    is      => "rw",
    isa     => "Num",
    default => 0,
);
has parsed_median => (
    is      => "rw",
    isa     => "Num",
    default => 0,
);
has parsed_mode   => (
    is      => "rw",
    isa     => "Str",
    default => 0,
);

before qr{\A parsed_ \w+ \z}mxs => sub {
    my $self = shift;

    $self->parse
        unless $self->is_parsed;
};

no Mouse;
__PACKAGE__->meta->make_immutable;

sub parse {
    my $self = shift;

    $self->is_parsed( 1 ); # avoid deep recursion.

    my @interval_list = map {
        App::WWW::ResponseTime::Log->from_string( $_ )->interval;
    } @{ $self->logs };

    my $vector = vector( @interval_list );

    $self->parsed_min( min( @interval_list ) );
    $self->parsed_max( max( @interval_list ) );
    $self->parsed_mean( "@{[mean( $vector )]}" );
    $self->parsed_median( q{} . median( $vector ) );
    $self->parsed_mode( q{} . mode( $vector ) );

    return $self;
}

sub basics {
    my $self   = shift;
    my @fields = qw( min max mean median mode );

    return sprintf
        join( q{, }, map { "$_: %s" } @fields ),
        map { my $prop = "parsed_$_"; $self->$prop } @fields;
}

sub as_string {
    my $self = shift;
    return $self->basics;
}

1;
__END__

=head1 NAME

App::WWW::ResponseTime::Stat - shows stat from log

=head1 SYNOPSIS

  use App::WWW::ResponseTime::Stat;

  my $stat = App::WWW::ResponseTime::Stat->new(
      logs => [ map { chomp; $_ } <> ],
  );

  say $stat;

=head1 DESCRIPTION

App::WWW::ResponseTime::Stat can show stat.

=head1 AUTHOR

kuniyoshi kouji E<lt>kuniyoshi@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
