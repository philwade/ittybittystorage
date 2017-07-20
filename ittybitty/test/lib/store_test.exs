defmodule Ittybitty.StoreTest do
  use ExUnit.Case, async: true

  defmodule RedisMock do
    def pipeline(_, [["GETBIT", "missing", 0], ["GETBIT", "missing", 1]]) do
      {:ok, [0, 0]}
    end

    def pipeline(_, [["GETBIT", "found", 0], ["GETBIT", "found", 1]]) do
      {:ok, [1, 0]}
    end

    def pipeline(_, [["GETBIT", "error", 0], ["GETBIT", "error", 1]]) do
      {:error}
    end

    def command(_, ["GETBIT", "missing", 0]) do
      {:ok, 0}
    end

    def command(_, ["GETBIT", "error", 0]) do
      {:error, "error"}
    end

    def command(_, ["GETBIT", "success", 0]) do
      {:ok, 1}
    end

    def command(_, ["SETBIT", "success", 1, 1]) do
      {:ok, 1}
    end
  end

  test "get_key missing" do
    assert Ittybitty.Store.get_key("missing", RedisMock) == {:notfound}
  end

  test "get_key found" do
    assert Ittybitty.Store.get_key("found", RedisMock) == {:ok, 0}
  end

  test "get_key error" do
    assert Ittybitty.Store.get_key("error", RedisMock) == {:error}
  end

  test "update_key missing" do
    assert Ittybitty.Store.update_key("missing", 1, RedisMock) == {:notfound}
  end

  test "update_key success" do
    assert Ittybitty.Store.update_key("success", 1, RedisMock) == {:ok, 1}
  end

  test "update_key error" do
    assert Ittybitty.Store.update_key("error", 1, RedisMock) == {:error, "error"}
  end

  test "invalid_key error" do
    assert Ittybitty.Store.update_key("invalid", 10) == {:invalid}
  end
end

