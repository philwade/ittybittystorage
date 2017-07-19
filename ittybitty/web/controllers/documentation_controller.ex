defmodule Ittybitty.DocumentationController do
  use Ittybitty.Web, :controller

  def about(conn, _params) do
    render conn, "about.html"
  end

  def documentation(conn, _params) do
    render conn, "documentation.html"
  end
end
