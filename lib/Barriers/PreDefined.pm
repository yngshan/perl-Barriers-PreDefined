package Barriers::PreDefined;

use strict;
use warnings;
use YAML::XS qw(LoadFile);
use File::ShareDir ();
use List::Util qw(first min max);
use Math::CDF qw(qnorm);
use Format::Util::Numbers qw(roundnear);

our $VERSION = '0.10';

=head1 NAME

Barriers::PreDefined - A class to calculate a series of predefined barriers for a particular contract.


=head1 SYNOPSIS

    use Barriers::PreDefined;
    my $available_barriers = Barriers::PreDefined->new->calculate_available_barriers($contract_type, $duration, $central_spot, $display_decimal, $method);

=head1 DESCRIPTION

This is a class to calculate a series of predefined barriers for a particular contract.

There are two available methods:

Method 1: (Unrounded version)
Steps:
1) Calculate the boundary barriers associated with a call at 5% and 95% probability.

2) Take the distance between the boundary barriers divide into 90 pieces which acts as the minimum_barrier_interval labeled as 'm'.

3) Build the barriers array from a central barrier[ which is the spot at the start of the window]. Barriers array are computed at a set number of barrier interval from the central spot as follow:
   Barrier_1 (labeled as 5) : central_spot - 45 * m
   Barrier_2 (labeled as 15) : central_spot - 35 * m
   Barrier_3 (labeled as 25) : central_spot - 25 * m
   Barrier_4 (labeled as 38) : central_spot - 12 * m
   Barrier_5 (labeled as 50) :  central_spot
   Barrier_6 (labeled as 62) : central_spot + 12 * m
   Barrier_7 (labeled as 75) : central_spot + 25 * m
   Barrier_8 (labeled as 85) : central_spot + 35 * m
   Barrier_9 (labeled as 95) : central_spot + 45 * m

4) Apply the barriers for each contract types as follow:
   - Single_barrier_european_option: The whole barriers array
   - Single_barrier_american_option: The whole barriers array except the central_spot
   - Double_barrier_european_option: 7 pairs associated with [lower_barrier, higher_barrier] as follow:
     [[75, 95], [62, 85], [50, 75], [38, 62], [25, 50], [15, 38], [5, 25]] 
   - Double_barrier_american_option: 3 pairs associated with [lower_barrier, higher_barrier] as follow:
     [[25, 75], [15, 85], [5, 95]],
 
Method 2: (Rounded version)
Steps:
1) Calculate  minimum_barrier_interval labeled as 'm', depending on magnitude of central_spot in base 10

2) Round the central_spot to nearest minimum_interval_barrier which will be named as rounded_central_spot

3) Calculate the boundary barriers associated with a call at 5% and 95% probability.

4) Build the barriers array from rounded_central_spot. Barriers array are computed at a set number of barrier interval from the rounded_central_spot as follow:
   Barrier_1 : rounded_central_spot + 45 * m
   Barrier_2 : rounded_central_spot + 28 * m
   Barrier_3 : rounded_central_spot + 18 * m
   Barrier_4 : rounded_central_spot + 7 * m
   Barrier_5 : rounded_central_spot
   Barrier_6 : rounded_central_spot - 7 * m
   Barrier_7 : rounded_central_spot - 18 * m
   Barrier_8 : rounded_central_spot - 28 * m
   Barrier_9 : rounded_central_spot - 45 * m

5) Build the new barriers array with ensuring the minimum_barrier_interval is hold as follow:
   New_barrier_1 (labeled as 95) : max( round(barrier_1/m) * m, new_barrier_2 + m )
   New_barrier_2 (labeled as 78) : max( round(barrier_2/m) * m, new_barrier_3 + m )
   New_barrier_3 (labeled as 68) : max( round(barrier_3/m) * m, new_barrier_4 + m )
   New_barrier_4 (labeled as 57) : max( round(barrier_4/m) * m, new_barrier_5 + m )
   New_barrier_5 (labeled as 50) : rounded_central_spot
   New_barrier_6 (labeled as 43) : min( round(barrier_6/m) * m, new_barrier_5 - m )
   New_barrier_7 (labeled as 32) : min( round(barrier_7/m) * m, new_barrier_6 - m )
   New_barrier_8 (labeled as 22) : min( round(barrier_8/m) * m, new_barrier_7 - m )
   New_barrier_9 (labeled as 5)  : min( round(barrier_9/m) * m, new_barrier_8 - m )

6) Apply the barriers for each contract types as follow:
   - Single_barrier_european_option: The whole barriers array
   - Single_barrier_american_option: The whole barriers array except the central_spot
   - Double_barrier_european_option: 7 pairs associated with [lower_barrier, higher_barrier] as follow:
     [[68, 95], [57, 78], [50, 68], [43, 57], [32, 50], [22, 43], [5, 32]]
   - Double_barrier_american_option: 3 pairs associated with [lower_barrier, higher_barrier] as follow:
     [[32, 68], [22, 78], [5, 95]]

=cut

=head1 ATTRIBUTES

=head2 contract_type

The contract type.

=head2 duration

The contract duration

=head2 central_spot

The spot at the start of the contract

=head2 display_decimal

The number of the display decimal

=head2 method

The method for the barrier calculation, method_1 or method_2

=head2 config_param

A configuration parameter contains the configuration of each contract type

=cut

my $config_param = LoadFile(File::ShareDir::dist_file('Barriers::PreDefined', 'contract_type_config.yml'));


=head1 METHODS

calculate_available_barriers($contract_type, $duration, $central_spot, $display_decimal, $method);

A function to calculate available barriers for a contract type


=cut

sub calculate_available_barriers {
    my ($contract_type, $duration, $central_spot, $display_decimal, $method) = @_;

    my $barriers_list = _calculate_barriers({
        duration        => $duration,
        central_spot    => $central_spot,
        display_decimal  => $display_decimal,
        method          => $method,
    });

    my $available_barriers;
    my @barriers_pairs  = @{$config_param->{$contract_type}->{$method}};
    my $barrier_type   = $confif_param->{$contract_type}->{barrier_type};    

    if ($barrier_type == 1) {
        $available_barriers = [ map {sprintf '%.' . $display_decimal . 'f', $barriers_list{$_}} @barrier_pairs;
    } elsif ($barrier_type == 2) {

        $available_barriers =
            [map { [sprintf '%.' . $display_decimal . 'f',$barriers_list->{$_->[0]}, sprintf '%.' . $display_decimal . 'f',$barriers->{$_->[1]}] } @barrier_pairs];
    }

    return $available_barriers;
}


1;

