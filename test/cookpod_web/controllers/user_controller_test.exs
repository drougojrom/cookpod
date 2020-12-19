defmodule CookpodWeb.UserControllerTest do
  use CookpodWeb.ConnCase
  use CookpodWeb.AuthUserCase

  alias Cookpod.Repo
  alias Cookpod.User

  @tag authenticated_user: true
  test "GET /users/new", %{conn: conn} do
    conn =
      conn
      |> get("/users/new")

    assert html_response(conn, 200) =~ "Sign up"
  end

  @tag authenticated_user: true
  test "it creates user if params are valid", %{conn: conn} do
    path = Routes.user_path(conn, :create)

    valid_params = %{
      "email" => "test@test.com",
      "password" => "123asdaA",
      "password_confirmation" => "123asdaA"
    }

    conn = post(conn, path, %{"user" => valid_params})

    user = Repo.get_by(User, email: "test@test.com")
    assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
    assert get_session(conn, :current_user).email == user.email
  end

  @tag authenticated_user: true
  test "it does not create user if params are invalid", %{conn: conn} do
    path = Routes.user_path(conn, :create)
    invalid_params = %{}

    conn = post(conn, path, %{"user" => invalid_params})

    user = Repo.get_by(User, email: "test@test.com")

    assert user == nil
  end
end
