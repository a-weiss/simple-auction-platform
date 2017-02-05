defmodule Auction.AuctionTest do
  use Auction.ModelCase

  alias Auction.Auction

  @valid_attrs %{brand: "some content", end_time: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, min_price: 42, picture: "some content", status: "some content", type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Auction.changeset(%Auction{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Auction.changeset(%Auction{}, @invalid_attrs)
    refute changeset.valid?
  end
end
