package Plack::Middleware::Profiler::DevelProfiler;
use strict;
use warnings;
use IPC::Cmd qw[run];

use parent qw(Plack::Middleware);
__PACKAGE__->mk_accessors(qw(mounts));

our $VERSION = '0.01';

BEGIN {
    require Devel::Profiler;
    Devel::Profiler->import;
    Devel::Profiler::init();
}

sub call {
    my ($self, $env) = @_;

    $self->start($env);
    my $res = $self->app->($env);
    $self->end($env);

    my $profiling_result = $self->analyze();
    my $report = $self->report($profiling_result);
    return $res;
}

sub start {
    my ( $self, $env ) = @_;
    # it's too late to start profile
}

sub end {
    Devel::Profiler::end();
}

sub analyze {
    my $profiling_result;
    my $buffer;
    my $cmd = 'dprofpp';
    if (scalar run(
            command => $cmd,
            verbose => 0,
            buffer  => \$buffer,
            timeout => 30
        )
        )
    {
        $profiling_result = $buffer;
    }
    else {
        $profiling_result = 'failed profiling';
    }
    $profiling_result;
}

sub report {
    my ($self, $result) = @_;
    print $result . "\n";
}

1;

__END__

=encoding utf-8

=head1 NAME

Plack::Middleware::Profiler -

=head1 SYNOPSIS

  use Plack::Middleware::Profiler;

=head1 DESCRIPTION

Plack::Middleware::Profiler is


=head1 SOURCE AVAILABILITY

This source is in Github:

  http://github.com/dann/

=head1 CONTRIBUTORS

Many thanks to:


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
