#!/usr/bin/perl

use strict;
use warnings;
use Test::More (tests => 2);
use Test::Deep;
use Test::FailWarnings;
use Barriers::PreDefined;

subtest 'get_avilable_barrier_method_1' => sub {
    plan tests => 8;

    my $method_1_config = [{
            types         => [qw/CALLE PUT/],
            barrier_level => [95, 85, 75, 62, 50, 38, 25, 15, 5],
        },
        {
            types         => [qw/ONETOUCH NOTOUCH/],
            barrier_level => [95, 85, 75, 62, 38, 25, 15, 5],
        },
        {
            types         => [qw/EXPIRYMISS EXPIRYRANGEE/],
            barrier_level => [75, 95, 62, 85, 50, 75, 38, 62, 25, 50, 15, 38, 5, 25],

        },
        {
            types         => [qw/RANGE UPORDOWN/],
            barrier_level => [25, 75, 15, 85, 5, 95,]
        },
    ];

    my $test_result = {
        'CALLE'    => ['100.45', '100.35', '100.25', '100.12', '100.00', '99.88', '99.75', '99.65', '99.55'],
        'PUT'      => ['100.45', '100.35', '100.25', '100.12', '100.00', '99.88', '99.75', '99.65', '99.55'],
        'ONETOUCH' => ['100.45', '100.35', '100.25', '100.12', '99.88',  '99.75', '99.65', '99.55'],
        'NOTOUCH'  => ['100.45', '100.35', '100.25', '100.12', '99.88',  '99.75', '99.65', '99.55'],
        'EXPIRYMISS' =>
            ['100.25', '100.45', '100.12', '100.35', '100.00', '100.25', '99.88', '100.12', '99.75', '100.00', '99.65', '99.88', '99.55', '99.75'],
        'EXPIRYRANGEE' =>
            ['100.25', '100.45', '100.12', '100.35', '100.00', '100.25', '99.88', '100.12', '99.75', '100.00', '99.65', '99.88', '99.55', '99.75'],
        'RANGE'    => ['99.75', '100.25', '99.65', '100.35', '99.55', '100.45'],
        'UPORDOWN' => ['99.75', '100.25', '99.65', '100.35', '99.55', '100.45'],
    };

    my $calculation_class = Barriers::PreDefined->new(config => $method_1_config);
    for my $type (keys %$test_result) {
        my $available_barriers = $calculation_class->calculate_available_barriers({
            contract_type   => $type,
            duration        => 2 * 60 * 60 + 15 * 60,
            central_spot    => 100,
            display_decimal => 2,
            method          => 1
        });
        cmp_bag($available_barriers, $test_result->{$type}, $type . ': available_barriers_match_for_method_1');
    }
};

subtest 'get_avilable_barrier_method_2' => sub {
    plan tests => 8;

    my $method_2_config = [{
            types         => [qw/CALLE PUT/],
            barrier_level => [95, 78, 68, 57, 50, 43, 32, 22, 5],
        },
        {
            types         => [qw/ONETOUCH NOTOUCH/],
            barrier_level => [95, 78, 68, 57, 43, 32, 22, 5],
        },
        {
            types         => [qw/EXPIRYMISS EXPIRYRANGEE/],
            barrier_level => [68, 95, 57, 78, 50, 68, 43, 57, 32, 50, 22, 43, 5, 32],
        },
        {
            types         => [qw/RANGE UPORDOWN/],
            barrier_level => [32, 68, 22, 78, 5, 95]
        },
    ];

    my $test_result = {
        'CALLE'    => ['100.45', '100.30', '100.20', '100.05', '100.00', '99.95', '99.80', '99.70', '99.55'],
        'PUT'      => ['100.45', '100.30', '100.20', '100.05', '100.00', '99.95', '99.80', '99.70', '99.55'],
        'ONETOUCH' => ['100.45', '100.30', '100.20', '100.05', '99.95',  '99.80', '99.70', '99.55'],
        'NOTOUCH'  => ['100.45', '100.30', '100.20', '100.05', '99.95',  '99.80', '99.70', '99.55'],
        'EXPIRYMISS' =>
            ['100.20', '100.45', '100.05', '100.30', '100.00', '100.20', '99.95', '100.05', '99.80', '100.00', '99.70', '99.95', '99.55', '99.80'],
        'EXPIRYRANGEE' =>
            ['100.20', '100.45', '100.05', '100.30', '100.00', '100.20', '99.95', '100.05', '99.80', '100.00', '99.70', '99.95', '99.55', '99.80'],
        'RANGE'    => ['99.80', '100.20', '99.70', '100.30', '99.55', '100.45'],
        'UPORDOWN' => ['99.80', '100.20', '99.70', '100.30', '99.55', '100.45'],
    };

    my $calculation_class = Barriers::PreDefined->new(config => $method_2_config);
    for my $type (keys %$test_result) {
        my $available_barriers = $calculation_class->calculate_available_barriers({
            contract_type   => $type,
            duration        => 2 * 60 * 60 + 15 * 60,
            central_spot    => 100,
            display_decimal => 2,
            method          => 2
        });
        cmp_bag($available_barriers, $test_result->{$type}, $type . ': available_barriers_match_for_method_2');
    }
    }
