# NAME

Barriers::PreDefined - A class to calculate a series of predefined barriers for a particular contract.

# SYNOPSIS

    use Barriers::PreDefined;
    my $available_barriers = Barriers::PreDefined->new->calculate_available_barriers({
                             config        => $config,
                             contract_type => $contract_type, 
                             duration      => $duration, 
                             central_spot  => $central_spot, 
                             display_decimal => $display_decimal,
                             method          => $method});

# DESCRIPTION

This is a class to calculate a series of predefined barriers for a particular contract.

There are two available methods:

Method 1: (Unrounded version)
Steps:
1) Calculate the boundary barriers associated with a call at 5% and 95% probability.

2) Take the distance between the boundary barriers divide into 90 pieces which acts as the minimum\_barrier\_interval labeled as 'm'.

3) Build the barriers array from a central barrier\[ which is the spot at the start of the window\]. Barriers array are computed at a set number of barrier interval from the central spot:
    
    Example: If the barrier\_interval are \[45,25,25,12\], the barriers\_array will be build as follow:

    Barrier_1 (labeled as 5) : central_spot - 45 * m
    
    Barrier_2 (labeled as 15) : central_spot - 35 * m
    
    Barrier_3 (labeled as 25) : central_spot - 25 * m
    
    Barrier_4 (labeled as 38) : central_spot - 12 * m
    
    Barrier_5 (labeled as 50) :  central_spot
    
    Barrier_6 (labeled as 62) : central_spot + 12 * m
    
    Barrier_7 (labeled as 75) : central_spot + 25 * m
    
    Barrier_8 (labeled as 85) : central_spot + 35 * m
    
    Barrier_9 (labeled as 95) : central_spot + 45 * m

4) Apply the barriers for each contract types as defined in the config file:
   Example: 
   - Single\_barrier\_european\_option: \[95, 85, 75, 62, 50, 38, 25, 15, 5\]
   - Single\_barrier\_american\_option: \[95, 85, 75, 62, 38, 25, 15, 5\]
   - Double\_barrier\_european\_option: \[75, 95, 62, 85, 50, 75, 38, 62, 25, 50, 15, 38, 5, 25\],
   - Double\_barrier\_american\_option: \[25, 75, 15, 85, 5, 95,\]

Steps:
1) Calculate  minimum\_barrier\_interval labeled as 'm', depending on magnitude of central\_spot in base 10

2) Round the central\_spot to nearest minimum\_interval\_barrier which will be named as rounded\_central\_spot

3) Calculate the boundary barriers associated with a call at 5% and 95% probability.

4) Build the barriers array from rounded\_central\_spot. Barriers array are computed at a set number of barrier interval from the rounded\_central\_spot.
   
   Example: If the barrier\_interval are \[45, 28, 18, 7\], the barriers\_array will be build as follow:
   
   Barrier\_1 : rounded\_central\_spot + 45 \* m
   
   Barrier\_2 : rounded\_central\_spot + 28 \* m
   
   Barrier\_3 : rounded\_central\_spot + 18 \* m
   
   Barrier\_4 : rounded\_central\_spot + 7 \* m
  
   Barrier\_5 : rounded\_central\_spot
  
   Barrier\_6 : rounded\_central\_spot - 7 \* m
  
   Barrier\_7 : rounded\_central\_spot - 18 \* m
  
   Barrier\_8 : rounded\_central\_spot - 28 \* m
  
   Barrier\_9 : rounded\_central\_spot - 45 \* m

5) Build the new barriers array with ensuring the minimum\_barrier\_interval is hold.
  
   Example: Example: If the barrier\_interval are \[45, 28, 18, 7\], the new\_barrier will be build as follow:
  
   New\_barrier\_1 (labeled as 95) : max( round(barrier\_1/m) \* m, new\_barrier\_2 + m )
  
   New\_barrier\_2 (labeled as 78) : max( round(barrier\_2/m) \* m, new\_barrier\_3 + m )
  
   New\_barrier\_3 (labeled as 68) : max( round(barrier\_3/m) \* m, new\_barrier\_4 + m )
  
   New\_barrier\_4 (labeled as 57) : max( round(barrier\_4/m) \* m, new\_barrier\_5 + m )
  
   New\_barrier\_5 (labeled as 50) : rounded\_central\_spot
  
   New\_barrier\_6 (labeled as 43) : min( round(barrier\_6/m) \* m, new\_barrier\_5 - m )
  
   New\_barrier\_7 (labeled as 32) : min( round(barrier\_7/m) \* m, new\_barrier\_6 - m )
  
   New\_barrier\_8 (labeled as 22) : min( round(barrier\_8/m) \* m, new\_barrier\_7 - m )
  
   New\_barrier\_9 (labeled as 5)  : min( round(barrier\_9/m) \* m, new\_barrier\_8 - m )

6) Apply the barriers for each contract types as defined in config file:
   Example: 
   - Single\_barrier\_european\_option: \[95, 78, 68, 57, 50, 43, 32, 22, 5\]
   - Single\_barrier\_american\_option: \[95, 78, 68, 57, 43, 32, 22, 5\]
   - Double\_barrier\_european\_option: \[68, 95, 57, 78, 50, 68, 43, 57, 32, 50, 22, 43, 5, 32\],
   - Double\_barrier\_american\_option: \[32, 68, 22, 78, 5, 95\]

# INPUT PARAMETERS

## config

A configuration hashref that contains the selected barrier level for a contract type

## contract\_type

The contract type.

## duration

The contract duration in seconds

## central\_spot

The spot at the start of the contract

## display\_decimal

The number of the display decimal point. Example 2 mean 0.01

## method

The method for the barrier calculation, method\_1 or method\_2

## \_contract\_barrier\_levels

A set of barrier level that intended to obtain for a contract type

Example: 
   - Single\_barrier\_european\_option: \[95, 78, 68, 57, 50, 43, 32, 22, 5\]
   - Single\_barrier\_american\_option: \[95, 78, 68, 57, 43, 32, 22, 5\]
   - Double\_barrier\_european\_option: \[68, 95, 57, 78, 50, 68, 43, 57, 32, 50, 22, 43, 5, 32\],
   - Double\_barrier\_american\_option: \[32, 68, 22, 78, 5, 95\]

The barrier level 78 is 28 \* min\_barrier\_interval from the central spot, while 22 is -28 \* min\_barrier\_interval from the central spot. 

# METHODS

## calculate\_available\_barriers

A function to calculate available barriers for a contract type
Input\_parameters: $contract\_type, $duration, $central\_spot, $display\_decimal, $method

## calculate\_method\_1

A function to build barriers array based on method 1
Input\_parameters: $duration, $central\_spot, $display\_decimal, $barriers\_levels

## calculate\_method\_2

A function to build barriers array based on method 2
Input\_parameters: $duration, $central\_spot, $display\_decimal, $barriers\_levels

## \_get\_barrier\_from\_call\_bs\_price
To get the barrier that associated with a given call bs price.
