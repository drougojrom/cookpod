defmodule CookpodWeb.AuthUserCase do
  use ExUnit.CaseTemplate

  import Plug.Conn

  setup do
    conn = Phoenix.ConnTest.build_conn()

    conn =
      conn
      |> with_valid_authorization_header()

    {:ok, current_user: %{name: "Dow", password: "123asdaA"}, conn: conn}
  end

  def with_valid_authorization_header(conn) do
    put_req_header(conn, "authorization", "Basic YWRtaW46cGFzc3dvcmQ=")
  end
end
