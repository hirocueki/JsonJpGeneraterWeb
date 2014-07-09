#!/usr/bin/env perl
use Mojolicious::Lite;
use utf8;
use JSON::PP;

plugin 'PODRenderer';

get '/reset' => sub {
  my $self = shift;
  $self->session(expires => 1);
  $self->redirect_to('/doit');
};

get '/developer' => sub {
  my $self = shift;

  $self->render('developer');
};

get '/usage' => sub {
  my $self = shift;

  $self->render('usage');
};

get '/' => sub {
  my $c = shift;

  $c->render('usage', datas => undef);
};

post '/doit' => sub {
  my $c = shift;


  # データの取得
  my $sec_datas = $c->session('datas');

  my $jp   = $c->param("jp");

  if ($jp ne "") {
    my $jsjp = JSON::PP->new->ascii(1)->allow_nonref(1)->encode($jp);

    $sec_datas->{$jp} = $jsjp;

    $c->session(datas => $sec_datas);
  }

  $c->render('index', datas => $sec_datas);
};

get '/doit' => sub {
  my $c = shift;


  # データの取得
  my $sec_datas = $c->session('datas');

  my $jp   = $c->param("jp");

  if ($jp ne "") {
    my $jsjp = JSON::PP->new->ascii(1)->allow_nonref(1)->encode($jp);

    $sec_datas->{$jp} = $jsjp;

    $c->session(datas => $sec_datas);
  }

  $c->render('index', datas => $sec_datas);
};


app->start;


__DATA__

@@ index.html.ep
% layout 'default';
% title 'JSONに貼り付ける日本語をつくる';
日本語 to JSON。

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head>
  <link rel="shortcut icon" href="<%= url_for '/favicon.ico' %>">
  <title><%= title %></title>

  <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
  </head>
  <body onload="document.jjgform.jp.focus();">
  <section class="container">

    <ul class="nav nav-pills">
      <li class="active"><a href="<%= url_for('/doit') %>">Home</a></li>
      <li><a href="<%= url_for('/usage') %>">Usage</a></li>
      <li><a href="<%= url_for('/developer') %>">Developer</a></li>
    </ul>

    <h1><%= content %></h1>

    <form method="post" name="jjgform" action="<%= url_for('/doit') %>">
      <input type="text" style="ime-mode:active;" class="form-control focusedInput" id="jp" name="jp" placeholder="please input japanese" />
      <button type="submit" class="btn btn-primary">doit!</button>
      % if (defined($datas) && scalar(keys(%$datas)) ) {
        <a href="<%= url_for('/reset') %>"><button type="button" class="btn btn-danger" >reset</button></a>
        <table class="table table-striped table-bordered table-hover">
          <tbody>
      % for my $key (keys(%$datas)) {
        <tr>
          <td><%= $key %></td>
          <td><%= $datas->{$key} %></td>
        </tr>
      % }
      </tbody>
    </table>
      % }
    </form>
    </section>
  </body>
</html>


@@ developer.html.ep
% layout 'common';
% title 'JSONに貼り付ける日本語をつくる';
<h1>なかの「ひと」。</h1>
<div class="jumbotron">
  <h1>高知県生まれ高知県育ち、<br>鰹たたき好きは大体友達</h1>
  <p>1984</p>
  <p>from kochi</p>
  <p>programmer</p>
  <a href="http://about.me/hirocueki" target="_blank" class="btn btn-success btn-lg" role="button">abount.me(hirocueki)</a>
</div>


@@ usage.html.ep
% layout 'common';
% title 'JSONに貼り付ける日本語をつくる';
<h1>できること。</h1>
<div class="jumbotron">
  <h1>JSONに”日本語”を。</h1>
  <p>JSONに日本語を入力。...文字化け</p>
  <p>エンコードすれば大丈夫。...日が暮れる</p>
  <p>その手間を--ちょっとだけ--解消させてください:)</p>
  <p><a href="<%= url_for('/doit') %>" class="btn btn-primary btn-lg" role="button">はじめる</a></p>
</div>


@@ layouts/common.html.ep
<!DOCTYPE html>
<html>
  <head>
  <link rel="shortcut icon" href="<%= url_for '/favicon.ico' %>">
  <title><%= title %></title>

  <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
  </head>
  <body>
  <section class="container">

    <ul class="nav nav-pills">
      <li class="active"><a href="<%= url_for('/doit') %>">Home</a></li>
      <li><a href="<%= url_for('/usage') %>">Usage</a></li>
      <li><a href="<%= url_for('/developer') %>">Developer</a></li>
    </ul>

    <%= content %>

    </section>
  </body>
</html>
