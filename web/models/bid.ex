defmodule Auction.Bid do
  use Auction.Web, :model

  schema "bids" do
    field :amount, :integer
    belongs_to :user, Auction.User
    belongs_to :auction, Auction.Auction

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:amount])
    |> validate_required([:amount])
  end
end
