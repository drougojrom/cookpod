defmodule CookpodWeb.Router do
  use CookpodWeb, :router
  use Plug.ErrorHandler
  import Plug.BasicAuth

  pipeline :browser do
    plug :basic_auth, username: "admin", password: "password"
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug CookpodWeb.AuthPlug
  end

  scope "/", CookpodWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/sessions", SessionController, singleton: true
    resources "/users", UserController, only: [:create]
  end

  scope "/", CookpodWeb do
    pipe_through [:browser, :protected]

    get "/terms", PageController, :terms
  end

  # Other scopes may use custom stacks.
  # scope "/api", CookpodWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: CookpodWeb.Telemetry
    end
  end

  require Logger

  def handle_errors(conn, %{kind: :error, reason: %Phoenix.Router.NoRouteError{}}) do
    conn
    |> fetch_session()
    |> fetch_flash()
    |> put_layout({CookpodWeb.LayoutView, :app})
    |> put_view(CookpodWeb.ErrorView)
    |> render("404.html")
  end

  def handle_errors(conn, %{kind: :error, reason: %Phoenix.ActionClauseError{}}) do
    conn
    |> fetch_session()
    |> fetch_flash()
    |> put_layout({CookpodWeb.LayoutView, :app})
    |> put_view(CookpodWeb.ErrorView)
    |> render("400.html")
  end

  def handle_errors(conn, _) do
    conn
  end
end
