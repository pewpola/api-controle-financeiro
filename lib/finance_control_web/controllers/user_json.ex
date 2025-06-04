defmodule FinanceControlWeb.UserJSON do
  alias FinanceControl.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      password_hash: user.password_hash,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
