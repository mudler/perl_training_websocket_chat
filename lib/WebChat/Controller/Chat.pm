package WebChat::Controller::Chat;
use Mojo::Base 'Mojolicious::Controller';
use DateTime;
my $clients = {};

# This action will render a template
sub message {
    my $self = shift;

    $self->app->log->debug( sprintf 'Client connected: %s', $self->tx );
    my $id = sprintf "%s", $self->tx;
    $clients->{$id} = $self->tx;

    $self->on(
        message => sub {
            my ( $self, $msg ) = @_;
            my $dt = DateTime->now( time_zone => 'Asia/Tokyo' );
            for ( keys %$clients ) {
                $clients->{$_}->send(
                    {
                        json => {
                            hms  => $dt->hms,
                            text => $msg,
                        }
                    }
                );
            }
        }
    );

    $self->on(
        finish => sub {
            $self->app->log->debug('Client disconnected');
            delete $clients->{$id};
        }
    );

}

1;
