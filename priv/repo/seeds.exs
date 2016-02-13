# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Trelm.Repo.insert!(%Trelm.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

data = [
  {"commas are rotated properly", nil},
  {"exclamation points stand up straight", nil},
  {"run-on sentences don't run forever", nil},
  {"question marks curl down, not up", nil},
  {"semicolons are adequately waterproof", nil},
  {"capital letters can do yoga", nil}
]

defmodule Seeds do

  def import_data(data) do
    Trelm.Repo.delete_all(Trelm.Test)
    Ecto.Adapters.SQL.query(Trelm.Repo, "alter sequence tests_id_seq restart", [])
    import_tests(data)
  end

  def import_tests([]), do: nil
  def import_tests([{description, test} = _|t]) do
    Trelm.Repo.insert!(%Trelm.Test{description: description, test: test})

    import_tests t
  end

end

Seeds.import_data(data)
