defmodule Schema.Polz do
use Absinthe.Schema
import_types Objects
# На Mutation и Query не разделял, так как нет смысла


subscription do

field :pervaya, :profile do     #название указывается в сабскрипшн и так называется в графкуэл. Возвращается тип данных
arg :namek, non_null (:string)   #определили переменную, куда будем ставить ключ для сабскрипшн. Если в subscription и query одно значение в этой переменной (ключ), то результат вылезет в Subscription
config fn %{namek: pam}, _->    #если в переменной установлено значение, то ->
{:ok, topic: pam}              #оно становится ключом. Ключ здесь примется, если придет то же самое значение ключа под той же переменной
end
end


field :vtoraya, list_of(list_of(:string)) do     
arg :room, non_null (:string) 
config fn 
%{room: pam}, _-> {:ok, topic: pam}
end
end







  





end




query do



field :mes, list_of(list_of(:string)) do
arg :room, non_null (:string)
arg :user, non_null (:string)
arg :mes, non_null (:string)
resolve &Resolvers.mes/2
end



field :profile, list_of(:profile) do
arg :name, non_null (:string)
resolve &Resolvers.profile/2
end




field :albumr, :string do
arg :user, non_null (:string)
arg :alb, non_null (:string)
resolve &Resolvers.albumr/2
end



field :photor, :string do
arg :user, non_null (:string)
arg :alb, non_null (:string)
arg :photo, non_null (:string)
resolve &Resolvers.photor/2
end


field :photos, list_of(:photos) do
arg :user, non_null (:string)
arg :alb, non_null (:string)
resolve &Resolvers.photos/2
end

field :rooms, list_of(list_of(list_of(:string))) do
resolve &Resolvers.rooms/2
end

field :room_info, list_of(:rooms) do
arg :room, non_null (:string)
resolve &Resolvers.room_info/2
end

field :notices, list_of(:notices) do
arg :name, non_null (:string)
resolve &Resolvers.notices/2
end




field :out, :string do
arg :room, non_null (:string)
arg :name, non_null (:string)
resolve &Resolvers.out/2
end



field :add, :string do
arg :room, non_null (:string)
arg :name, non_null (:string)
resolve &Resolvers.add/2
end



field :roomr, :string do
arg :room, non_null (:string)
resolve &Resolvers.roomr/2
end

field :room, :string do
arg :room, non_null (:string)
resolve &Resolvers.room/2
end


field :ls,  list_of(list_of(:string)) do
arg :to, non_null (:string)
arg :from, non_null (:string)
arg :mes, non_null (:string)
resolve &Resolvers.ls/2
end




field :photo_like, :string do
arg :to, non_null (:string)
arg :from, non_null (:string)
arg :alb, non_null (:string)
arg :photo, non_null (:string)
resolve &Resolvers.photo_like/2
end



field :albums, list_of(:string) do
arg :user, non_null (:string)
resolve &Resolvers.albums/2
end

field :photo, :string do
arg :user, non_null (:string)
arg :alb, non_null (:string)
arg :name, non_null (:string)
resolve &Resolvers.photo/2
end


field :album, :string do
arg :user, non_null (:string)     
arg :alb, non_null (:string)
resolve &Resolvers.album/2
end




field :age, :string do
arg :name, non_null (:string)
arg :age, non_null (:integer)
resolve &Resolvers.age/2
end

field :email, :string do
arg :name, non_null (:string)
arg :email, non_null (:string)
resolve &Resolvers.email/2
end

field :avatar, :string do
arg :name, non_null (:string)
arg :avatar, non_null (:string)
resolve &Resolvers.avatar/2
end

field :search, list_of(:string) do
arg :name, non_null (:string)
resolve &Resolvers.search/2
end


field :unfriend, :string do
arg :login1, non_null (:string)
arg :login2, non_null (:string)
resolve &Resolvers.unfriend/2
end

field :accept, :string do
arg :login1, non_null (:string)
arg :login2, non_null (:string)
resolve &Resolvers.accept/2
end

field :request, :string do
arg :login1, non_null (:string)
arg :login2, non_null (:string)
arg :ask, non_null (:string)
resolve &Resolvers.request/2
end



field :reg, :string do
arg :name, non_null (:string)
arg :password, non_null (:string)
resolve &Resolvers.reg/2
end

field :auth, :string do
arg :name, non_null (:string)
arg :password, non_null (:string)
resolve &Resolvers.auth/2
end


field :logout, :string do
arg :name, non_null (:string)
resolve &Resolvers.logout/2
end


end



end
















