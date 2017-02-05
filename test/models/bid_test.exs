defmodule Auction.BidTest do
  use Auction.ModelCase

  alias Auction.Bid

  @valid_attrs %{amount: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Bid.changeset(%Bid{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Bid.changeset(%Bid{}, @invalid_attrs)
    refute changeset.valid?
  end
end
