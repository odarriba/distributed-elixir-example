defmodule DistributedElixir.Web.PageController do
  use DistributedElixir.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
