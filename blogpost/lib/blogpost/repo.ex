defmodule Blogpost.Repo do
  use Ecto.Repo,
    otp_app: :blogpost,
    adapter: Ecto.Adapters.Postgres
end
