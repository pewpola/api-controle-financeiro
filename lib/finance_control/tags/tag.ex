# lib/finance_control/tags/tag.ex
defmodule FinanceControl.Tags.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    belongs_to :user, FinanceControl.Accounts.User
    many_to_many :transactions, FinanceControl.Transactions.Transaction, join_through: "transactions_tags"

    timestamps()
  end

  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
