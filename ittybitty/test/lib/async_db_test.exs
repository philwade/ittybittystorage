defmodule Ittybitty.AsyncDBTest do
  use ExUnit.Case
  use Ittybitty.ConnCase
  alias Ittybitty.Repo
  alias Ittybitty.Bit

  def get_key_mock(key) do
    {:ok, 1}
  end

  test "update key" do
    testchange = Bit.changeset(%Bit{})
    testbit = Repo.insert!(testchange)

    Ittybitty.AsyncDB.update_key(testbit.id, &get_key_mock/1)
    bit = Repo.get!(Bit, testbit.id)
    assert bit.value == true
  end
end
