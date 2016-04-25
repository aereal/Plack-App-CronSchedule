requires 'perl', '5.008001';

# requires 'Crontab::Stats'; # TODO
requires 'Data::Section::Simple';
requires 'JSON::XS';
requires 'Parse::Crontab';
requires 'Plack';
requires 'Text::MicroTemplate';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

