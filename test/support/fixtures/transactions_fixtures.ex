defmodule FinanceControl.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FinanceControl.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        date: ~N[2025-06-03 02:36:00],
        description: "some description",
        type: "some type",
        value: "120.5"
      })
      |> FinanceControl.Transactions.create_transaction()

    transaction
  end
end
