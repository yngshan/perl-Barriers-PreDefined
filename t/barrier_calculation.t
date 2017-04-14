#!/usr/bin/perl

use strict;
use warnings;
use Test::More (tests => 2);
use Test::Deep;
use Test::FailWarnings;
use Barriers::PreDefined;
my $method_2_config = [
            {
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




subtest 'get_avilable_barrier_method_1' => sub {
    plan tests => 1;

    my $method_1_config = [
            {
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

    my $calculation_class = Barriers::PreDefined->new(config        => $method_1_config);
    my $available_barriers = $calculation_class->calculate_available_barriers({
                             contract_type => 'CALLE', 
                             duration      => 2 *60*60, 
                             central_spot  => 100, 
                             display_decimal => 2,
                             method          => 1});
    my $expected_barriers = ['100.27', '100.21', '100.15', '100.09' ,'100.00', '99.91', '99.85', '99.79', '99.73'];

    cmp_bag($available_barriers, $expected_barriers, 'available_barriers_match_for_method_1'); 

}
