defmodule Auction.Repo.Migrations.CreateBid do
  use Ecto.Migration

  def change do
    create table(:bids) do
      add :amount, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :auction_id, references(:auctions, on_delete: :nothing)

      timestamps()
    end
    create index(:bids, [:user_id])
    create index(:bids, [:auction_id])

  end
end
