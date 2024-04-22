defmodule RouteWise.Repo do
  use Ecto.Repo,
    otp_app: :route_wise,
    adapter: Ecto.Adapters.Postgres
end
