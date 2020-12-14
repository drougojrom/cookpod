defmodule CookpodWeb.SessionControllerTest do
  use CookpodWeb.ConnCase
  use CookpodWeb.AuthUserCase

  @tag authenticated_user: true
  test "GET /sessions/new", %{conn: conn} do
    conn =
      conn
      |> get("/sessions/new")

    assert html_response(conn, 200) =~ "Log in"
  end

  @tag authenticated_user: true
  test "POST /sessions", %{conn: conn} do
    path = Routes.session_path(conn, :create)

    conn =
      conn
      |> post(path, %{user: %{name: "Dow", password: "123asdaA"}})

    assert get_session(conn, :current_user) == "Dow"
    assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
  end

  @tag authenticated_user: true
  test "DELETE /sessions/delete", %{conn: conn} do
    path = Routes.session_path(conn, :delete)

    conn =
      conn
      |> init_test_session(%{current_user: "Dow"})
      |> delete(path)

    assert get_session(conn, :current_user) == nil
    assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
  end

  @tag authenticated_user: true
  test "GET /sessions/", %{conn: conn} do
    conn =
      conn
      |> init_test_session(%{current_user: "Dow"})

    assert get_session(conn, :current_user) == "Dow"
  end
end
