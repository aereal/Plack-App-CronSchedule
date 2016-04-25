package Plack::App::CronSchedule::View;

use strict;
use warnings;

use Data::Section::Simple qw(get_data_section);
use Text::MicroTemplate qw(build_mt);

sub new {
  my ($class) = @_;
  my $template = get_data_section('index.html.mt');
  my $renderer = build_mt($template);
  my $self = bless {
    renderer => $renderer,
  }, $class;
  return $self;
}

sub render {
  my ($self, $args) = @_;
  return $self->{renderer}->($args);
}

1;

__DATA__

@@ index.html.mt
<? my ($args) = @_; ?>
<? my ($jobs_series) = @$args{qw(jobs_series)} ?>
<!doctype>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Crontab Schedules</title>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/skeleton/2.0.4/skeleton.min.css">
    <style>
      #daily-chart {
        width: 100%;
        height: 100%;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>Cron Schedules</h1>
      <div id="daily-chart" class="chart" data-json="<?= $jobs_series ?>"></div>
    </div>
    <script src="//www.google.com/jsapi"></script>
    <script>
      var defs = ['daily'];
      google.load('visualization', '1', { packages: ['corechart']});
      google.setOnLoadCallback(function () {
        defs.forEach(def => {
          var series = JSON.parse(document.getElementById(def + '-chart').getAttribute('data-json'));
          var dataArray = [
              ['ID', 'Hour', 'Weekday', '', 'count'],
          ].concat(series);
          var data = google.visualization.arrayToDataTable(dataArray);

          var options = {
              hAxis: {
                  title: 'Hour',
                  ticks: [0, 4, 7, 10, 13, 19, 22],
              },
              vAxis: {
                  title: 'Weekday',
                  maxValue: 8,
                  minValue: 0,
                  ticks: [
                      { v: 1, f: "Sun" },
                      { v: 2, f: "Mon" },
                      { v: 3, f: "Tue" },
                      { v: 4, f: "Wed" },
                      { v: 5, f: "Thu" },
                      { v: 6, f: "Fri" },
                      { v: 7, f: "Sat" },
                  ],
              },
              width: '100%',
              height: '100%',
          };

          var chart = new google.visualization.BubbleChart(document.getElementById(def + '-chart'));
          chart.draw(data, options);
        })
      });
    </script>
  </body>
</html>

