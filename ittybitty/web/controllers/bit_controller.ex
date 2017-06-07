defmodule Ittybitty.BitController do
  use Ittybitty.Web, :controller

  def show(conn, %{"id" => id}) do
    case Ittybitty.Redix.get_key(id) do
      {:ok, value} ->
        json conn, %{value: value}
      {:notfound} ->
            put_status(conn, 404)
            |> render(Ittybitty.ErrorView, "404.json")
    end
  end
end
