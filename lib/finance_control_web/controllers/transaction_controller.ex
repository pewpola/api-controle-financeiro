defmodule FinanceControlWeb.TransactionController do
  use FinanceControlWeb, :controller

  alias FinanceControl.Transactions
  alias FinanceControl.Transactions.Transaction
  alias FinanceControl.Guardian

  action_fallback FinanceControlWeb.FallbackController

  def index(conn, _params) do
    with %FinanceControl.Accounts.User{id: user_id} <- Guardian.Plug.current_resource(conn) do
      transactions = Transactions.list_user_transactions(user_id)
      render(conn, :index, transactions: transactions)
    else
      _ -> {:error, :unauthorized}
    end
  end

  def create(conn, %{"transaction" => transaction_params}) do
    with %FinanceControl.Accounts.User{id: user_id} <- Guardian.Plug.current_resource(conn),
         params <- Map.put(transaction_params, "user_id", user_id),
         {:ok, %Transaction{} = transaction} <- Transactions.create_transaction(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/transactions/#{transaction}")
      |> render(:show, transaction: transaction)
    else
      _ -> {:error, :unauthorized}
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(id)
    render(conn, :show, transaction: transaction)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Transactions.get_transaction!(id)

    with {:ok, %Transaction{} = updated} <- Transactions.update_transaction(transaction, transaction_params) do
      render(conn, :show, transaction: updated)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(id)

    with {:ok, %Transaction{}} <- Transactions.delete_transaction(transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
