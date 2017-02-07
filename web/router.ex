defmodule Auction.Router do
  use Auction.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Auction do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController do
      resources "/auctions", AuctionController
      resources "/bids", BidController, only: [:index, :show]
    end
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/auctions", AuctionController do
      resources "/bids", BidController, only: [:index, :new, :create, :show]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Auction do
  #   pipe_through :api
  # end
end
