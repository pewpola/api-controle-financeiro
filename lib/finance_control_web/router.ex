defmodule FinanceControlWeb.Router do
  use FinanceControlWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug Guardian.Plug.Pipeline,
      module: FinanceControl.Guardian,
      error_handler: FinanceControlWeb.AuthErrorHandler

    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  scope "/api", FinanceControlWeb do
    pipe_through :api

    post "/login", AuthController, :login
    post "/users", UserController, :create
  end

  scope "/api", FinanceControlWeb do
    pipe_through :api_auth

    resources "/users", UserController, except: [:new, :edit, :create]
    resources "/transactions", TransactionController, except: [:new, :edit]
    resources "/tags", TagController, except: [:new, :edit]
  end
end
