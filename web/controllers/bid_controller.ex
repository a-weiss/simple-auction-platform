defmodule Auction.BidController do
  use Auction.Web, :controller

  alias Auction.Bid
  alias Auction.User

  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]


  def index(conn, _params) do
    bids = Repo.all(Bid)
    render(conn, "index.html", bids: bids)
  end

  def new(conn, _params) do
    changeset = Bid.changeset(%Bid{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bid" => bid_params}) do
    changeset = Bid.changeset(%Bid{}, bid_params)

    case Repo.insert(changeset) do
      {:ok, _bid} ->
        conn
        |> put_flash(:info, "Bid created successfully.")
        |> redirect(to: user_bid_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bid = Repo.get!(Bid, id)
    render(conn, "show.html", bid: bid)
  end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
        case Repo.get(User, user_id) do
          nil  -> invalid_user(conn)
          user -> assign(conn, :user, user)
        end
      _ -> invalid_user(conn)
    end
  end

  defp invalid_user(conn) do
    conn
    |> put_flash(:error, "Invalid user!")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end

  defp authorize_user(conn, _opts) do
    user = get_session(conn, :current_user)
    if user && Integer.to_string(user.id) == conn.params["user_id"] do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that post!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
