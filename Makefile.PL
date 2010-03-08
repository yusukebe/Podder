use inc::Module::Install;
name 'Podder';
all_from 'lib/Podder.pm';

requires 'Mouse';
requires 'Mouse::Role';
requires 'MouseX::Types::Path::Class';
requires 'Pod::Simple::XHTML';
requires 'Text::VimColor';
requires 'Carp';
requires 'Path::Class';
requires 'Template';
requires 'DateTime';
requires 'DateTime::TimeZone::Local';
requires 'Plack::Request';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
