# priv/repo/migrations/20230614123756_create_transactions_tags.exs
defmodule FinanceControl.Repo.Migrations.CreateTransactionsTags do
  use Ecto.Migration

  def change do
    create table(:transactions_tags) do
      add :transaction_id, references(:transactions, on_delete: :delete_all), null: false
      add :tag_id, references(:tags, on_delete: :delete_all), null: false
    end

    create index(:transactions_tags, [:transaction_id])
    create index(:transactions_tags, [:tag_id])
    create unique_index(:transactions_tags, [:transaction_id, :tag_id], name: :transaction_tag_unique)
  end
end
