defmodule CookpodWeb.FallbackPlug do

  @moduledoc """
  Plug for fallback
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    Plug.Conn.send_resp(conn, 200, "I'm a fallback")
  end
end
