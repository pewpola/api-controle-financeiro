defmodule FinanceControl.Repo do
  use Ecto.Repo,
    otp_app: :finance_control,
    adapter: Ecto.Adapters.Postgres
end
