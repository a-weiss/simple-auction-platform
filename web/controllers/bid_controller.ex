defmodule Auction.BidController do
  require Logger
  use Auction.Web, :controller

  alias Auction.Bid
  alias Auction.User

  plug :scrub_params, "bid" when action in [:create]
  plug :assign_user
  plug :assign_auction


  def index(conn, _params) do
    if conn.params["user_id"] do
      bids = Repo.all(assoc(conn.assigns[:user], :bids))
    else
      bids = Repo.all(assoc(conn.assigns[:auction], :bids))
    end
    render(conn, "index.html", bids: bids)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:auction]
      |> build_assoc(:bids)
      |> Bid.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bid" => bid_params}) do
    changeset =
      %Bid{user_id: conn.assigns[:user].id, auction_id: conn.assigns[:auction].id}
      |> Bid.changeset(bid_params)
    case Repo.insert(changeset) do
      {:ok, _bid} ->
        conn
        |> put_flash(:info, "Bid created successfully.")
        |> redirect(to: auction_bid_path(conn, :index, conn.assigns[:auction]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bid = Repo.get!(Bid, id)
    render(conn, "show.html", bid: bid)
  end

  defp assign_user(conn, _opts) do
    user = Repo.get(User, get_session(conn, :current_user).id)
    assign(conn, :user, user)
  end

  defp assign_auction(conn, _opts) do
    case conn.params do
      %{"auction_id" => auction_id} ->
        auction = Repo.get(Auction.Auction, auction_id)
        assign(conn, :auction, auction)
      _ ->
        conn
    end
  end

end
