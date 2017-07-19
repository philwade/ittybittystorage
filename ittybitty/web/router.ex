defmodule Ittybitty.Router do
  use Ittybitty.Web, :router

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

  scope "/", Ittybitty do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/newbit", BitController, :verify
    get "/newbit", BitController, :new
    get "/documentation", DocumentationController, :documentation
    get "/about", DocumentationController, :about
  end

  # Other scopes may use custom stacks.
   scope "/api", Ittybitty, as: :api do
     pipe_through :api

	 resources "/bit", BitController, only: [:show, :update, :delete]
   end
end
