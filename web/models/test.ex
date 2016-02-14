defmodule Trelm.Test do
  use Trelm.Web, :model

  schema "tests" do
    field :description, :string
    field :test, :string

    timestamps
  end

  @required_fields ~w(description test)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end

defimpl Poison.Encoder, for: Trelm.Test do
  def encode(model, opts) do
    %{id: model.id,
      description: model.description,
      test: model.test || "",
      status: "PENDING"} |> Poison.Encoder.encode(opts)
  end
end
