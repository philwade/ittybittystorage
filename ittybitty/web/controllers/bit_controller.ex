defmodule Ittybitty.BitController do
  use Ittybitty.Web, :controller

  def show(conn, %{"id" => id}) do
    case Ittybitty.Store.get_key(id) do
      {:ok, value} ->
        json conn, %{value: value}
      {:notfound} ->
            put_status(conn, 404)
            |> render(Ittybitty.ErrorView, "404.json")
    end
  end

  def update(conn, %{"id" => key, "value" => value}) do
    case Ittybitty.Store.update_key(key, value) do
      {:notfound} ->
        put_status(conn, 404)
        |> render(Ittybitty.ErrorView, "404.json")
      {:ok, val} ->
        json conn, %{value: val}
    end
  end

  def verify(conn, _params) do
  end

  def new(conn, _params) do
    key = Ittybitty.Store.generate_key()
    case Ittybitty.Store.create_key(key) do
      {:ok, _} ->
        render conn, "new.html", key: key
      {:error, msg} ->
        put_status(conn, 500)
        |> render(Ittybitty.ErrorView, "500.html")
    end
  end
end
