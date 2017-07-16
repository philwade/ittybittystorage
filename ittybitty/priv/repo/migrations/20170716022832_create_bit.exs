defmodule Ittybitty.Repo.Migrations.CreateBit do
  use Ecto.Migration

  def change do
    create table(:bits, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :value, :boolean, default: false, null: false

      timestamps()
    end

  end
end
