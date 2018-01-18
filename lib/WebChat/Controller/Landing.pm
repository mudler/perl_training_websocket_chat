package WebChat::Controller::Landing;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub index {
  my $self = shift;

  $self->render('index');
}

1;
