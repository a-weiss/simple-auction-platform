defmodule Auction.BidControllerTest do
  use Auction.ConnCase

  alias Auction.Bid
  @valid_attrs %{amount: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, bid_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing bids"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, bid_path(conn, :new)
    assert html_response(conn, 200) =~ "New bid"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, bid_path(conn, :create), bid: @valid_attrs
    assert redirected_to(conn) == bid_path(conn, :index)
    assert Repo.get_by(Bid, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, bid_path(conn, :create), bid: @invalid_attrs
    assert html_response(conn, 200) =~ "New bid"
  end

  test "shows chosen resource", %{conn: conn} do
    bid = Repo.insert! %Bid{}
    conn = get conn, bid_path(conn, :show, bid)
    assert html_response(conn, 200) =~ "Show bid"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, bid_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    bid = Repo.insert! %Bid{}
    conn = get conn, bid_path(conn, :edit, bid)
    assert html_response(conn, 200) =~ "Edit bid"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    bid = Repo.insert! %Bid{}
    conn = put conn, bid_path(conn, :update, bid), bid: @valid_attrs
    assert redirected_to(conn) == bid_path(conn, :show, bid)
    assert Repo.get_by(Bid, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bid = Repo.insert! %Bid{}
    conn = put conn, bid_path(conn, :update, bid), bid: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit bid"
  end

  test "deletes chosen resource", %{conn: conn} do
    bid = Repo.insert! %Bid{}
    conn = delete conn, bid_path(conn, :delete, bid)
    assert redirected_to(conn) == bid_path(conn, :index)
    refute Repo.get(Bid, bid.id)
  end
end
