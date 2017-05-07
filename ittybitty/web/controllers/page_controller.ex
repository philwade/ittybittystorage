defmodule Ittybitty.PageController do
  use Ittybitty.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
