defmodule Cookpod.User do
  @moduledoc """
  User model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email])
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 4)
    |> validate_email()
    |> encrypt_password()
    |> unique_constraint(:email)
  end

  def new_changeset() do
    changeset(%Cookpod.User{}, %{})
  end

  def encrypt_password(changeset) do
    case Map.fetch(changeset.changes, :password) do
      {:ok, password} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))

      :error ->
        changeset
    end
  end

  defp validate_email(changeset) do
    changeset
    |> get_field(:email)
    |> check_email(changeset)
  end

  defp check_email(nil, changeset), do: changeset

  defp check_email(email, changeset) do
    case Regex.run(~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i, email) do
      nil ->
        add_error(changeset, :email, "has invalid format email", validation: :format)

      _ ->
        changeset
    end
  end
end
