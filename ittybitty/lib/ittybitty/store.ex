defmodule Ittybitty.Store do
  @setbit 0
  @valuebit 1

  def get_key(key) do
    case Redix.pipeline(:redix, [["GETBIT", key, @setbit], ["GETBIT", key, @valuebit]]) do
      {:ok, [0, _]} ->
        {:notfound}
      {:ok, [1, val]} ->
        {:ok, val}
      _ ->
        {:error}
    end
  end

  def update_key(key, value) do
    case Redix.command(:redix, ["GETBIT", key, @setbit]) do
      {:ok, 1} -> update_key_value(key, value)
      {:ok, 0} -> {:notfound}
      {:error, msg} -> {:error, msg}
    end
  end

  defp update_key_value(key, value) do
    Redix.command(:redix, ["SETBIT", key, @valuebit, value])
  end

  def create_key(key) do
    Redix.pipeline(:redix, [["SETBIT", key, @setbit, 1], ["SETBIT", key, @valuebit, 1]])
  end
end
