defmodule Cookpod.Recipes.Recipe do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias Cookpod.Picture

  schema "recipes" do
    field :description, :string
    field :name, :string
    field :picture, Picture.Type

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :description, :picture])
    |> cast_attachments(attrs, [:picture])
    |> validate_required([:name, :description, :picture])
    |> unique_constraint(:name)
  end
end
