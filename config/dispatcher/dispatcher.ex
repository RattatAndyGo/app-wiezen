defmodule Dispatcher do
  use Matcher
  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ]
  ]

  @any %{}
  @json %{ accept: %{ json: true } }
  @html %{ accept: %{ html: true } }

  define_layers [ :static, :services, :fall_back, :not_found ]

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule:
  #
  # match "/themes/*path", @json do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end
  #
  # Run `docker-compose restart dispatcher` after updating
  # this file.

  match "/positions/*path", @json do
    Proxy.forward conn, path, "http://resource/positions/"
  end

  match "/players/*path", @json do
    Proxy.forward conn, path, "http://resource/players/"
  end

  match "/rounds/*path", @json do
    Proxy.forward conn, path, "http://resource/rounds/"
  end

  match "/hands/*path", @json do
    Proxy.forward conn, path, "http://resource/hands/"
  end

  match "/points/*path", @json do
    Proxy.forward conn, path, "http://resource/points/"
  end

  match "/*_", %{ layer: :not_found } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end
end
