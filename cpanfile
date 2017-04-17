requires 'Moo';
requires 'POSIX';
requires 'Math::CDF';

on configure => sub {
    requires 'ExtUtils::MakeMaker';
};


on test => sub {
    requires 'Test::More';
    requires 'Test::FailWarnings';
};

on build => sub {
   requires 'Moo';
   requires 'POSIX';
   requires 'Math::CDF';

};
