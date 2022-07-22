defmodule Blogs.Repo do
  use Ecto.Repo,
    otp_app: :blogs,
    adapter: Ecto.Adapters.Postgres
end
