defmodule FinanceControlWeb.UserController do
  use FinanceControlWeb, :controller

  alias FinanceControl.Accounts
  alias FinanceControl.Accounts.User
  alias FinanceControl.Guardian

  action_fallback FinanceControlWeb.FallbackController

  def index(conn, _params) do
    with %User{} <- Guardian.Plug.current_resource(conn) do
      users = Accounts.list_users()
      render(conn, :index, users: users)
    else
      _ -> {:error, :unauthorized}
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
        {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render("auth.json", %{user: user, token: token})
    end
  end


  def show(conn, %{"id" => id}) do
    with %User{} <- Guardian.Plug.current_resource(conn),
         %User{} = user <- Accounts.get_user!(id) do
      render(conn, :show, user: user)
    else
      _ -> {:error, :not_found}
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    with %User{} <- Guardian.Plug.current_resource(conn),
         %User{} = user <- Accounts.get_user!(id),
         {:ok, %User{} = updated_user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: sanitize_user(updated_user))
    else
      _ -> {:error, :not_found}
    end
  end

  def delete(conn, %{"id" => id}) do
    with %User{} <- Guardian.Plug.current_resource(conn),
         %User{} = user <- Accounts.get_user!(id),
         {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    else
      _ -> {:error, :not_found}
    end
  end

  defp sanitize_user(user) do
    %{user | password_hash: nil, password: nil}
  end
end
