defmodule Ittybitty.AsyncDB do
  require Logger
  alias Ittybitty.Bit
  alias Ittybitty.Repo

  @doc "Update a key's value in the postgres"
  def update_key(key, get_key \\ &Ittybitty.Store.get_key/1) do
    case get_key.(key) do
      {:ok, val} ->
        update_db(key, val)
      {:error} ->
        Logger.error "Error retrieving #{key}"
    end
  end

  defp update_db(key, val) do
    case cast_value(val) do
      {:ok, cast_value} ->
        bit = Repo.get!(Bit, key)
        changeset = Bit.changeset(bit, %{value: cast_value})
        case Repo.update(changeset) do
          {:ok, bit} -> {:ok, bit}
          {:error, _} ->
            Logger.error "Unable to update value for #{key}"
        end
      {:error} ->
        Logger.error "Invalid value for #{key}"
    end
  end

  defp cast_value(val) do
    case val do
      0 -> {:ok, false}
      1 -> {:ok, true}
      _ -> {:error}
    end
  end
end
