defmodule Cookpod.Factory do
  use ExMachina.Ecto, repo: Cookpod.Repo

  alias Cookpod.User

  def user_factory do
    password = sequence(:password, &"password#{&1}")
    password_hash = Argon2.hash_pwd_salt(password)

    %User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: password,
      password_hash: password_hash
    }
  end
end
