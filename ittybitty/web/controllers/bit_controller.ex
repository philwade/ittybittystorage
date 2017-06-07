defmodule Ittybitty.BitController do
  use Ittybitty.Web, :controller

  def show(conn, %{"id" => id}) do
    case Ittybitty.Redix.get_key(id) do
      {:ok, value} ->
        json conn, %{value: value}
      _ -> text conn, "error"
    end
  end
end
