use Test::Dependencies
    exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic Plack::Middleware::Profiler/],
    style   => 'light';
ok_dependencies();
