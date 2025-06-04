defmodule FinanceControlWeb.AuthJSON do
  def auth(%{user: user, token: token}) do
    %{
      data: %{
        id: user.id,
        name: user.name,
        email: user.email,
        token: token
      }
    }
  end
end
