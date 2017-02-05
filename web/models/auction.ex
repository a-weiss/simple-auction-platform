defmodule Auction.Auction do
  use Auction.Web, :model

  schema "auctions" do
    field :brand, :string
    field :type, :string
    field :picture, :string
    field :min_price, :integer
    field :end_time, Ecto.DateTime
    field :status, :string
    belongs_to :user, Auction.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:brand, :type, :picture, :min_price, :end_time])
    |> validate_required([:brand, :type, :picture, :min_price, :end_time])
    |> init_status
  end

  defp init_status(changeset) do
    changeset
    |> put_change(:status, "started")
  end

end
