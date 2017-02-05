defmodule Auction.Repo.Migrations.CreateAuction do
  use Ecto.Migration

  def change do
    create table(:auctions) do
      add :brand, :string
      add :type, :string
      add :picture, :string
      add :min_price, :integer
      add :end_time, :datetime
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:auctions, [:user_id])

  end
end
