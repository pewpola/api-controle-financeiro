defmodule FinanceControlWeb.TagController do
  use FinanceControlWeb, :controller

  alias FinanceControl.Tags
  alias FinanceControl.Tags.Tag
  alias FinanceControl.Guardian

  action_fallback FinanceControlWeb.FallbackController

  def index(conn, _params) do
    with %FinanceControl.Accounts.User{id: user_id} <- Guardian.Plug.current_resource(conn) do
      tags = Tags.list_user_tags(user_id)
      render(conn, :index, tags: tags)
    else
      _ -> {:error, :unauthorized}
    end
  end

  def create(conn, %{"tag" => tag_params}) do
    with %FinanceControl.Accounts.User{id: user_id} <- Guardian.Plug.current_resource(conn),
         params <- Map.put(tag_params, "user_id", user_id),
         {:ok, %Tag{} = tag} <- Tags.create_tag(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tags/#{tag}")
      |> render(:show, tag: tag)
    else
      _ -> {:error, :unauthorized}
    end
  end

  def show(conn, %{"id" => id}) do
    tag = Tags.get_tag!(id)
    render(conn, :show, tag: tag)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    tag = Tags.get_tag!(id)

    with {:ok, %Tag{} = tag} <- Tags.update_tag(tag, tag_params) do
      render(conn, :show, tag: tag)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Tags.get_tag!(id)

    with {:ok, %Tag{}} <- Tags.delete_tag(tag) do
      send_resp(conn, :no_content, "")
    end
  end
end
