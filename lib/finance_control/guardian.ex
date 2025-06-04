defmodule FinanceControl.Guardian do
  use Guardian, otp_app: :finance_control

  alias FinanceControl.Accounts.User

  def subject_for_token(%User{id: id}, _claims), do: {:ok, to_string(id)}
  def subject_for_token(_, _), do: {:error, :invalid_resource}

  def resource_from_claims(%{"sub" => id}) do
    case FinanceControl.Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
  def resource_from_claims(_), do: {:error, :invalid_claims}
end
