defmodule CookpodWeb.PageControllerTest do
  use CookpodWeb.ConnCase

  def with_valid_authorization_header(conn) do
    conn
    |> put_req_header("authorization", "Basic YWRtaW46cGFzc3dvcmQ=")
  end

  test "GET /", %{conn: conn} do
    conn =
      conn
      |> with_valid_authorization_header()
      |> get("/")

    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
