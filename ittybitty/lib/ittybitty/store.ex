defmodule Ittybitty.Store do
  @setbit 0
  @valuebit 1

  def get_key(key, redis \\ Redix) do
    case redis.pipeline(:redix, [["GETBIT", key, @setbit], ["GETBIT", key, @valuebit]]) do
      {:ok, [0, _]} ->
        {:notfound}
      {:ok, [1, val]} ->
        {:ok, val}
      _ ->
        {:error}
    end
  end

  def update_key(key, value, redis \\ Redix) do
    unless valid_value(value) do
      {:invalid}
    else
      case redis.command(:redix, ["GETBIT", key, @setbit]) do
        {:ok, 1} -> update_key_value(key, value, redis)
        {:ok, 0} -> {:notfound}
        {:error, msg} -> {:error, msg}
      end
    end
  end

  def valid_value(val) do
    case val do
      1 -> true
      0 -> true
      "1" -> true
      "0" -> true
      _ -> false
    end
  end

  defp update_key_value(key, value, redis) do
    redis.command(:redix, ["SETBIT", key, @valuebit, value])
  end

  def create_key(key, redis \\ Redix) do
    redis.pipeline(:redix, [["SETBIT", key, @setbit, 1], ["SETBIT", key, @valuebit, 1]])
  end
end
