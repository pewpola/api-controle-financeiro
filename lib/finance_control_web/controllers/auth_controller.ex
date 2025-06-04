# lib/finance_control_web/controllers/auth_controller.ex
defmodule FinanceControlWeb.AuthController do
  use FinanceControlWeb, :controller

  alias FinanceControl.Accounts.User
  alias FinanceControl.Guardian

  action_fallback FinanceControlWeb.FallbackController

  def register(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- FinanceControl.Repo.insert(User.changeset(%User{}, user_params)),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("auth.json", %{user: user, token: token})
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    with %User{} = user <- FinanceControl.Repo.get_by(User, email: email),
         true <- Bcrypt.verify_pass(password, user.password_hash),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> render("auth.json", %{user: user, token: token})
    else
      _ -> {:error, :unauthorized}
    end
  end
end
