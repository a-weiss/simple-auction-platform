defmodule Auction.AuctionControllerTest do
  use Auction.ConnCase

  alias Auction.Auction
  @valid_attrs %{brand: "some content", end_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, min_price: 42, picture: "some content", status: "some content", type: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, auction_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing auctions"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, auction_path(conn, :new)
    assert html_response(conn, 200) =~ "New auction"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, auction_path(conn, :create), auction: @valid_attrs
    assert redirected_to(conn) == auction_path(conn, :index)
    assert Repo.get_by(Auction, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, auction_path(conn, :create), auction: @invalid_attrs
    assert html_response(conn, 200) =~ "New auction"
  end

  test "shows chosen resource", %{conn: conn} do
    auction = Repo.insert! %Auction{}
    conn = get conn, auction_path(conn, :show, auction)
    assert html_response(conn, 200) =~ "Show auction"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, auction_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    auction = Repo.insert! %Auction{}
    conn = get conn, auction_path(conn, :edit, auction)
    assert html_response(conn, 200) =~ "Edit auction"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    auction = Repo.insert! %Auction{}
    conn = put conn, auction_path(conn, :update, auction), auction: @valid_attrs
    assert redirected_to(conn) == auction_path(conn, :show, auction)
    assert Repo.get_by(Auction, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    auction = Repo.insert! %Auction{}
    conn = put conn, auction_path(conn, :update, auction), auction: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit auction"
  end

  test "deletes chosen resource", %{conn: conn} do
    auction = Repo.insert! %Auction{}
    conn = delete conn, auction_path(conn, :delete, auction)
    assert redirected_to(conn) == auction_path(conn, :index)
    refute Repo.get(Auction, auction.id)
  end
end
