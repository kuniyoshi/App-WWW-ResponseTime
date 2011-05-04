use inc::Module::Install;
name 'App-WWW-ResponseTime';
all_from 'lib/App/WWW/ResponseTime.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
