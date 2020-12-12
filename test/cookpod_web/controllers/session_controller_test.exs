defmodule CookpodWeb.SessionControllerTest do
  use CookpodWeb.ConnCase

  def with_valid_authorization_header(conn) do
    conn
    |> put_req_header("authorization", "Basic YWRtaW46cGFzc3dvcmQ=")
  end

  test "GET /sessions/new", %{conn: conn} do
    conn =
      conn
      |> with_valid_authorization_header()
      |> get("/sessions/new")

    assert html_response(conn, 200) =~ "Log in"
  end

  test "POST /sessions", %{conn: conn} do
    path = Routes.session_path(conn, :create)

    conn =
      conn
      |> with_valid_authorization_header()
      |> post(path, %{user: %{name: "Dow", password: "123asdaA"}})

    assert get_session(conn, :current_user) == "Dow"
    assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
  end

  test "DELETE /sessions/delete", %{conn: conn} do
    path = Routes.session_path(conn, :delete)

    conn =
      conn
      |> with_valid_authorization_header()
      |> init_test_session(%{current_user: "Dow"})
      |> delete(path)

    assert get_session(conn, :current_user) == nil
    assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
  end
end
