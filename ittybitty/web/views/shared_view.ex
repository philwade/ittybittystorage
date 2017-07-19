defmodule Ittybitty.SharedView do
  use Ittybitty.Web, :view
  alias Ittybitty.Bit
  alias Ittybitty.Repo

  def bit_count() do
    Repo.aggregate(Bit, :count, :id)
  end
end
