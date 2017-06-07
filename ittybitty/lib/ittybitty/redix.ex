defmodule Ittybitty.Redix do
  def get_key(key) do
    case Redix.pipeline(:redix, [["GETBIT", key, 0], ["GETBIT", key, 1]]) do
      {:ok, [0, _]} ->
        {:notfound}
      {:ok, [1, val]} ->
        {:ok, val}
      _ ->
        {:error}
    end
  end
end
