#perl
use strict;
use warnings;
use Parse::File::Metadata;
use Test::More qw(no_plan); # tests =>  6;

my ($file, $header_split, $metaref, @rules);
my $self;
my ($dataprocess, $metadata_out, $exception);
my $expected_metadata;

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

($metadata_out, $exception) = $self->process_metadata_only();
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
ok( ! $exception, "No exception:  all metadata criteria met" );

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

($metadata_out, $exception) = $self->process_metadata_only();
$expected_metadata = {
    a => q{alpha},
    b => q{beta,charlie,delta},
    c => q{epsilon	zeta	eta},
    d => q{1234567890},
    e => q{This is a string},
};
is_deeply( $metadata_out, $expected_metadata,
    "Got expected metadata" );
ok( $exception, "Metadata criteria not met" );
is( $exception, q{'f' key must exist},
    "Got expected metadata criterion label" );

# 3
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

($metadata_out, $exception) = $self->process_metadata_only();
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
ok( ! $exception, "No exception:  all metadata criteria met" );

pass("Completed all tests in $0");