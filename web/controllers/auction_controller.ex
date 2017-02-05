defmodule Auction.AuctionController do
  use Auction.Web, :controller

  alias Auction.Auction

  def index(conn, _params) do
    auctions = Repo.all(Auction)
    render(conn, "index.html", auctions: auctions)
  end

  def new(conn, _params) do
    changeset = Auction.changeset(%Auction{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"auction" => auction_params}) do
    changeset = Auction.changeset(%Auction{}, auction_params)

    case Repo.insert(changeset) do
      {:ok, _auction} ->
        conn
        |> put_flash(:info, "Auction created successfully.")
        |> redirect(to: auction_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    auction = Repo.get!(Auction, id)
    render(conn, "show.html", auction: auction)
  end

  def edit(conn, %{"id" => id}) do
    auction = Repo.get!(Auction, id)
    changeset = Auction.changeset(auction)
    render(conn, "edit.html", auction: auction, changeset: changeset)
  end

  def update(conn, %{"id" => id, "auction" => auction_params}) do
    auction = Repo.get!(Auction, id)
    changeset = Auction.changeset(auction, auction_params)

    case Repo.update(changeset) do
      {:ok, auction} ->
        conn
        |> put_flash(:info, "Auction updated successfully.")
        |> redirect(to: auction_path(conn, :show, auction))
      {:error, changeset} ->
        render(conn, "edit.html", auction: auction, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    auction = Repo.get!(Auction, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(auction)

    conn
    |> put_flash(:info, "Auction deleted successfully.")
    |> redirect(to: auction_path(conn, :index))
  end
end
