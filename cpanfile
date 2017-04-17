requires 'Moo';
requires 'POSIX';
requires 'List::Util';
requires 'List::MoreUtils';
requires 'Math::CDF';

on test => sub {
    requires 'Test::More';
    requires 'Test::Deep';
    requires 'Test::FailWarnings';
};

on build => sub {
   requires 'Moo';
   requires 'POSIX';
   requires 'List::Util';
   requires 'List::MoreUtils';
   requires 'Math::CDF';

};
