defmodule Auction.AuctionController do
  use Auction.Web, :controller

  alias Auction.User
  alias Auction.Auction

  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]

  def index(conn, _params) do
    auctions = Repo.all(assoc(conn.assigns[:user], :auctions))
    render(conn, "index.html", auctions: auctions)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:auctions)
      |> Auction.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"auction" => auction_params}) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:auctions)
      |> Auction.changeset(auction_params)

    case Repo.insert(changeset) do
      {:ok, _auction} ->
        conn
        |> put_flash(:info, "Auction created successfully.")
        |> redirect(to: user_auction_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    auction = Repo.get!(assoc(conn.assigns[:user], :auctions), id)
    render(conn, "show.html", auction: auction)
  end

  def edit(conn, %{"id" => id}) do
    auction = Repo.get!(assoc(conn.assigns[:user], :auctions), id)
    changeset = Auction.changeset(auction)
    render(conn, "edit.html", auction: auction, changeset: changeset)
  end

  def update(conn, %{"id" => id, "auction" => auction_params}) do
    auction = Repo.get!(assoc(conn.assigns[:user], :auctions), id)
    changeset = Auction.changeset(auction, auction_params)

    case Repo.update(changeset) do
      {:ok, auction} ->
        conn
        |> put_flash(:info, "Auction updated successfully.")
        |> redirect(to: user_auction_path(conn, :show, conn.assigns[:user], auction))
      {:error, changeset} ->
        render(conn, "edit.html", auction: auction, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    auction = Repo.get!(assoc(conn.assigns[:user], :auctions), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(auction)

    conn
    |> put_flash(:info, "Auction deleted successfully.")
    |> redirect(to: user_auction_path(conn, :index, conn.assigns[:user]))
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
      |> put_flash(:error, "You are not authorized to modify that bid!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
