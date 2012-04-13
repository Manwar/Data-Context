use strict;
use warnings;
use Test::More;# tests => 2;
use Path::Class;
use Data::Dumper qw/Dumper/;

use Data::Context;
use Data::Context::Instance;
my $dc = Data::Context->new(
    path => file($0)->parent->subdir('dc') . '',
);

test_object();
test_sort();

done_testing;

sub test_object {
    my $dci = Data::Context::Instance->new(
        path => 'data',
        file => file($0)->parent->file('dc/data.dc.js'),
        type => 'js',
        dc   => $dc,
    )->init;

    ok $dci, 'get an object back';
    #diag Dumper $dci->raw;
    #diag Dumper $dci->actions;
    #diag Dumper $dci->get_data({test=>{value=>['replace']}});

    $dci = Data::Context::Instance->new(
        path => 'deep/child',
        file => file($0)->parent->file('dc/deep/child.dc.yml'),
        type => 'yaml',
        dc   => $dc,
    )->init;

    ok $dci, 'get an object back';
    is $dci->raw->{basic}, 'text', 'Get data from parent config';
    #diag Dumper $dci->raw;
}

sub test_sort {
    my @tests = (
        {
            four  => { found => 1, order => -1 },
            two   => { found => 2, order => undef },
            three => { found => 3, order => undef },
            one   => { found => 4, order => 1 },
        } => [ qw/ one two three four / ],
    );
    my $sorted = [ Data::Context::Instance::_sort_optional( $tests[0] ) ];

    is_deeply $sorted, $tests[1], "Sorted correctly"
        or diag Dumper $sorted, $tests[1];
}