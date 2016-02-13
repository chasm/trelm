defmodule Trelm.PageController do
  use Trelm.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
