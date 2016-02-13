defmodule Trelm.Repo.Migrations.CreateTest do
  use Ecto.Migration

  def change do
    create table(:tests) do
      add :description, :text
      add :test, :string

      timestamps
    end

  end
end
