use inc::Module::Install;
name 'App-WWW-ResponseTime';
all_from 'lib/App/WWW/ResponseTime.pm';

requires "Statistics::Basic";
requires "Mouse";
requires "List::MoreUtils";
requires "DateTime";
requires "DateTime::Format::Strptime";

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
