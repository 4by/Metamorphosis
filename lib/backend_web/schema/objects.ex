defmodule Objects do
use Absinthe.Schema.Notation




object :profile do
field :photo_albums, list_of(:string) 
field :friends, list_of(:string)  
field :name, :string
field :email, :string
field :age, :integer
field :avatar, :string
field :online, :boolean
end

object :notices do
field :name, :string
field :requests, list_of(list_of(:string))
field :messages, list_of(list_of(:string))
field :likes, list_of(list_of(:string))
end

object :rooms do
field :room, :string
field :messages, list_of(list_of(:string))
field :users, (list_of(:string))
end


object :photos do
field :name, :string
field :like, list_of(list_of(:string))
end


end