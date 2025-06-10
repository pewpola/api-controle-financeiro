defmodule FinanceControl.Repo.Migrations.RemoveDateFromTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      remove :date
    end
  end
end
