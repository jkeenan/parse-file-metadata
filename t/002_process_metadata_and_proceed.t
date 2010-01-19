#perl
use strict;
use warnings;
use Parse::File::Metadata;
use Test::More tests => 22;

my ($file, $header_split, $metaref, @rules);
my $self;
my ($dataprocess, $metadata_out, $exception);
my $expected_metadata;
my %exceptions_seen;

# 1
$file = 't/amyfile.txt';
$header_split = '=';
$metaref = {};
@rules = (
    { label => q{'d' key must exist},
        rule => sub { exists $metaref->{d}; } },
    { label => q{'d' key must be non-negative integer},
        rule => sub { $metaref->{d} =~ /^\d+$/; } },
    { label => q{'f' key must exist},
        rule => sub { exists $metaref->{f}; } },
);

$self = Parse::File::Metadata->new( {
    file            => $file,
    header_split    => $header_split,
    metaref         => $metaref,
    rules           => \@rules,
} );
isa_ok( $self, 'Parse::File::Metadata' );

$dataprocess = sub { my @fields = split /,/, $_[0], -1; };

($metadata_out, $exception) = $self->process_metadata_and_proceed( $dataprocess );
$expected_metadata = {
    a => q{alpha},
    b => q{beta,charlie,delta},
    c => q{epsilon	zeta	eta},
    d => q{1234567890},
    e => q{This is a string},
    f => q{,},
};
is_deeply( $metadata_out, $expected_metadata,
    "Got expected metadata" );
ok( ! scalar @{$exception}, "No exception:  all metadata criteria met" );

# 2
$file = 't/bmyfile.txt';
$header_split = '=';
$metaref = {};
@rules = (
    { label => q{'d' key must exist},
        rule => sub { exists $metaref->{d}; } },
    { label => q{'d' key must be non-negative integer},
        rule => sub { $metaref->{d} =~ /^\d+$/; } },
    { label => q{'f' key must exist},
        rule => sub { exists $metaref->{f}; } },
);

$self = Parse::File::Metadata->new( {
    file            => $file,
    header_split    => $header_split,
    metaref         => $metaref,
    rules           => \@rules,
} );
isa_ok( $self, 'Parse::File::Metadata' );

$dataprocess = sub { my @fields = split /,/, $_[0], -1; };

($metadata_out, $exception) = $self->process_metadata_and_proceed( $dataprocess );
$expected_metadata = {
    a => q{alpha},
    b => q{beta,charlie,delta},
    c => q{epsilon	zeta	eta},
    d => q{1234567890},
    e => q{This is a string},
};
is_deeply( $metadata_out, $expected_metadata,
    "Got expected metadata" );
ok( $exception->[0], "Metadata criteria not met" );
is( $exception->[0], q{'f' key must exist},
    "Got expected metadata criterion label" );

# 3
$file = 't/amyfile.txt';
$header_split = '=';
$metaref = {};
@rules = (
    { label => q{'d' key must exist},
        rule => sub { exists $metaref->{d}; } },
    { label => q{'d' key must be non-negative integer},
        rule => sub { $metaref->{d} =~ /^\d+$/; } },
    { label => q{'f' key must exist},
        rule => sub { exists $metaref->{f}; } },
);

$self = Parse::File::Metadata->new( {
    file            => $file,
    header_split    => $header_split,
    metaref         => $metaref,
    rules           => \@rules,
} );
isa_ok( $self, 'Parse::File::Metadata' );

$dataprocess = undef;
eval {
    ($metadata_out, $exception) =
        $self->process_metadata_and_proceed( $dataprocess );
};
like( $@, qr/^Must define subroutine for processing data rows/,
    "Got expected error:  process_metadata_and_proceed() argument undefined" );

eval {
    ($metadata_out, $exception) =
        $self->process_metadata_and_proceed( [ qw( a b c ) ] );
};
like( $@, qr/^Must define subroutine for processing data rows/,
    "Got expected error:  process_metadata_and_proceed() wrong argument type" );

# 4
$file = 't/cmyfile.txt';
$header_split = '=';
$metaref = {};
@rules = (
    { label => q{'d' key must exist},
        rule => sub { exists $metaref->{d}; } },
    { label => q{'d' key must be non-negative integer},
        rule => sub { $metaref->{d} =~ /^\d+$/; } },
    { label => q{'f' key must exist},
        rule => sub { exists $metaref->{f}; } },
);

$self = Parse::File::Metadata->new( {
    file            => $file,
    header_split    => $header_split,
    metaref         => $metaref,
    rules           => \@rules,
} );
isa_ok( $self, 'Parse::File::Metadata' );

$dataprocess = sub { my @fields = split /,/, $_[0], -1; };

($metadata_out, $exception) = $self->process_metadata_and_proceed( $dataprocess );
$expected_metadata = {
    a => q{alpha},
    b => q{beta,charlie,delta},
    c => q{epsilon	zeta	eta},
    d => q{1234567890},
    e => q{This is a string},
    f => q{,},
};
is_deeply( $metadata_out, $expected_metadata,
    "Got expected metadata" );
ok( ! scalar @{$exception}, "No exception:  all metadata criteria met" );

# 5
$file = 't/dmyfile.txt';
$header_split = '\s*=\s*';
$metaref = {};
@rules = (
    { label => q{'d' key must exist},
        rule => sub { exists $metaref->{d}; } },
    { label => q{'d' key must be non-negative integer},
        rule => sub { $metaref->{d} =~ /^\d+$/; } },
    { label => q{'f' key must exist},
        rule => sub { exists $metaref->{f}; } },
);

$self = Parse::File::Metadata->new( {
    file            => $file,
    header_split    => $header_split,
    metaref         => $metaref,
    rules           => \@rules,
} );
isa_ok( $self, 'Parse::File::Metadata' );

$dataprocess = sub { my @fields = split /,/, $_[0], -1; };

($metadata_out, $exception) = $self->process_metadata_and_proceed( $dataprocess );
$expected_metadata = {
    a => q{alpha},
    b => q{beta,charlie,delta},
    c => q{epsilon	zeta	eta},
    d => q{1234567890},
    e => q{This is a string},
    f => q{,},
};
is_deeply( $metadata_out, $expected_metadata,
    "Got expected metadata" );
ok( ! scalar @{$exception}, "No exception:  all metadata criteria met" );

# 6
$file = 't/emyfile.txt';
$header_split = '=';
$metaref = {};
@rules = (
    { label => q{'d' key must exist},
        rule => sub { exists $metaref->{d}; } },
    { label => q{'d' key must be non-negative integer},
        rule => sub { $metaref->{d} =~ /^\d+$/; } },
    { label => q{'f' key must exist},
        rule => sub { exists $metaref->{f}; } },
);

$self = Parse::File::Metadata->new( {
    file            => $file,
    header_split    => $header_split,
    metaref         => $metaref,
    rules           => \@rules,
} );
isa_ok( $self, 'Parse::File::Metadata' );

$dataprocess = sub { my @fields = split /,/, $_[0], -1; };

($metadata_out, $exception) = $self->process_metadata_and_proceed( $dataprocess );
$expected_metadata = {
    a => q{alpha},
    b => q{beta,charlie,delta},
    c => q{epsilon	zeta	eta},
    d => q{This is not a non-negative integer},
    e => q{This is a string},
};
is_deeply( $metadata_out, $expected_metadata,
    "Got expected metadata" );
is(scalar @{$exception}, 2, "Got 2 metadata rule failures");
%exceptions_seen = map {$_  => 1 } @{$exception};
ok( exists $exceptions_seen{q|'d' key must be non-negative integer|},
    "Got expected failure label" );
ok( exists $exceptions_seen{q|'f' key must exist|},
    "Got expected failure label" );

pass("Completed all tests in $0");
