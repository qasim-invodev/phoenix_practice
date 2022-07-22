defmodule BlogpostWeb.PageController do
  use BlogpostWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
