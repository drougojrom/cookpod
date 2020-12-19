defmodule CookpodWeb.PageControllerTest do
  use CookpodWeb.ConnCase
  use CookpodWeb.AuthUserCase

  @tag authenticated_user: true
  test "GET /", %{conn: conn} do
    conn =
      conn
      |> get("/")

    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
