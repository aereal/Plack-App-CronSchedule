package Plack::App::CronSchedule;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use parent qw(Plack::Component);
use Plack::Util::Accessor qw( crontab_files );

use Crontab::Stats::ByHour;
use Data::Section::Simple qw(get_data_section);
use JSON::XS;
use Parse::Crontab;
use Text::MicroTemplate qw(build_mt);

use Plack::App::CronSchedule::View;

sub prepare_app {
  my ($self) = @_;
  my $view = Plack::App::CronSchedule::View->new;
  $self->{view} = $view;
  my $jobs = [ map { Parse::Crontab->new(file => $_)->jobs } @{$self->crontab_files} ];
  my $stats = Crontab::Stats::ByHour->new($jobs);
  $self->{render_args} = {
    jobs_series => JSON::XS->new->space_before(1)->space_after(1)->canonical(1)->encode($stats->as_series),
  };
}

sub call {
  my ($self, $env) = @_;
  my $rendered = $self->{view}->render($self->{render_args});

  return [
    200,
    [
      'Content-Type' => 'text/html; charset=utf-8',
    ],
    [$rendered],
  ];
}

1;
__END__

=encoding utf-8

=head1 NAME

Plack::App::CronSchedule - It's new $module

=head1 SYNOPSIS

    use Plack::App::CronSchedule;

=head1 DESCRIPTION

Plack::App::CronSchedule is ...

=head1 LICENSE

Copyright (C) aereal.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

aereal E<lt>aereal@aereal.orgE<gt>

=cut

