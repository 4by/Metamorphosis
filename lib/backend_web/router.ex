defmodule BackendWeb.Router do
use BackendWeb, :router

#pipeline :api do
# plug :accepts, ["json"]
#end

#scope "/api", BackendWeb do
#  pipe_through :api
#end
#end
scope "/polz" do
forward "/graphiql",   #вместо форвард тоже можно гет и пост
Absinthe.Plug.GraphiQL,
schema: Schema.Polz,
socket_url: "ws://localhost:4000/polz"
end

scope "/admin" do #forward можно только в одной
get "/graphiql",
Absinthe.Plug.GraphiQL,
schema: Schema.Admin,
socket_url: "ws://localhost:4000/admin"

post "/graphiql",
Absinthe.Plug.GraphiQL,
schema: Schema.Admin,
socket_url: "ws://localhost:4000/admin"
end


end