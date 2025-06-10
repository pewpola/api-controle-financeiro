defmodule FinanceControl.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @types ~w(RECEITA DESPESA)

  schema "transactions" do
    field :description, :string
    field :value, :decimal
    field :type, :string
    # field :date, :naive_datetime
    belongs_to :user, FinanceControl.Accounts.User
    many_to_many :tags, FinanceControl.Tags.Tag, join_through: "transactions_tags"

    timestamps()
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:description, :value, :type, :user_id])
    |> validate_required([:description, :value, :type, :user_id])
    |> validate_inclusion(:type, @types)
    |> foreign_key_constraint(:user_id)
  end
end
