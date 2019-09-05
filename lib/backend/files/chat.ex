defmodule Chat do
use Ecto.Schema
import Ecto.Changeset

schema "chats" do
field :name, {:array, :string}
field :history, {:array, {:array, :string}}, default: []
many_to_many :users, User, join_through: "chats_users", on_delete: :delete_all #это для repo.delete в удалении комнаты (а в юзере он реплейс в этом месте)
end

def changeset(user, attrs \\ %{}) do
user
|> cast(attrs, ~w[name]a)
|> validate_required(~w[name]a)

#   |> assoc_constraint(:user)  #проверяем, что такой овнер есть
end


def room(room) do
if  Enum.any?(Chat |> Repo.all, fn(x) -> x.name == [room] end) do
{:ok, "Комната уже существует"}
 else
Chat.changeset(%Chat{}, %{name: [room]}) |> Repo.insert()
l = %Chat{} |> Chat.changeset(%{name: [room]})
if l.valid? do
{:ok, "Комната создана"}
end
end
end

def roomr(name) do
if Enum.any?(Chat |> Repo.all |> Repo.preload(:users), fn(x) -> x.name == [name] end) do
Repo.get_by(Chat, name: [name]) |> Repo.delete 
{:ok, "Комната удалена"}
else {:ok, "Комната не была создана"}
end
end

def out(room, name) do
if Enum.any?(User |> Repo.all, fn(x) -> x.name == name end) do
if Enum.any?(Chat |> Repo.all |> Repo.preload(:users), fn(x) -> x.name == [room] end) do
a = Ecto.Changeset.change(Repo.get_by(User, name: name) |> Repo.preload(:chats))
b = Enum.filter((Repo.get_by(User, name: name) |> Repo.preload(:chats)).chats, fn(x) -> x.name != [room] end)
Ecto.Changeset.put_assoc(a, :chats, b) |> Repo.update 
{:ok, "Пользователь удален из комнаты"}
else {:ok, "Комнаты не существует"}
end
else {:ok, "Пользователя не существует"}
end
end

def add(room, name) do
if  Enum.any?(User |> Repo.all, fn(x) -> x.name == name end) do
a = Ecto.Changeset.change(Repo.get_by(User, name: name) |> Repo.preload(:chats))
b = [Repo.get_by(Chat, name: [room]) | (Repo.get_by(User, name: name) |> Repo.preload(:chats)).chats]
if Repo.get_by(Chat, name: [room]) == nil do
{:ok, "Комната не была создана"}
else
Ecto.Changeset.put_assoc(a, :chats, b) |> Repo.update 
{:ok, "Пользователь добавлен"}
end
else {:ok, "Пользователя не существует"}
end
end

def rooms do
 Enum.flat_map(Repo.preload(Chat |> Repo.all, :users), fn(x) ->  if length(x.name) == 1 do [x.name, Enum.map(x.users, fn(y) -> y.name end)] else [] end  end)
end


def see(room) do
if Enum.any?(Chat |> Repo.all |> Repo.preload(:users), fn(x) -> x.name == [room] end) do
%{room: [room], users: Enum.map(Repo.preload(Repo.get_by(Chat, name: [room]), :users).users, fn(x) -> x.name end),
messages: Repo.preload(Repo.get_by(Chat, name: [room] ), :users).history}
else
%{room: "Такой комнаты нет", users: [], messages: [] }
end
end

def mes(room, user, mes) do
if  Enum.any?(User |> Repo.all, fn(x) -> x.name == user end) do
if Repo.get_by(User, name: user).online == true do
if Enum.any?(Chat |> Repo.all, fn(x) -> x.name == [room] end) do
case Enum.any?(Repo.preload(Repo.get_by(Chat, name: [room]), :users).users, fn(x) -> x.name == user end) do
false -> [["Пользователь не находится в комнате"]]
true ->  
Ecto.Changeset.put_change(Ecto.Changeset.change(Repo.get_by(Chat, name: [room])) , :history,  Repo.get_by(Chat, name: [room]).history ++ [["#{Repo.get_by(User, name: user).name}", mes]]) |> Repo.update  
Repo.preload(Repo.get_by(Chat, name: [room]), :users).history
end
else [["Комната не была создана"]]
end
else [["Вход не выполнен"]]
end
else [["Пользователя не существует"]]
end
end


def ls(to, from, mes) do
if  Enum.any?(User |> Repo.all, fn(x) -> x.name == to end) do
if  Enum.any?(User |> Repo.all, fn(x) -> x.name == from end) do
if Repo.get_by(User, name: from).online == true do
unless Enum.any?(Chat |> Repo.all |> Repo.preload(:users), fn(x) -> x.name == ["#{Repo.get_by(User, name: to).name}", "#{Repo.get_by(User, name: from).name}"] end) do
unless Enum.any?(Chat |> Repo.all |> Repo.preload(:users), fn(x) -> x.name == ["#{Repo.get_by(User, name: from).name}", "#{Repo.get_by(User, name: to).name}"] end) do 
Chat.changeset(%Chat{}, %{name: [to, from]}) |> Repo.insert()
Ecto.Changeset.put_assoc(Ecto.Changeset.change(Repo.get_by(User, name: to) |> Repo.preload(:chats)), :chats, [Repo.get_by(Chat, name: [to, from]) | (Repo.get_by(User, name: to) |> Repo.preload(:chats)).chats]) |> Repo.update 
Ecto.Changeset.put_assoc(Ecto.Changeset.change(Repo.get_by(User, name: from) |> Repo.preload(:chats)), :chats, [Repo.get_by(Chat, name: [to, from]) | (Repo.get_by(User, name: from) |> Repo.preload(:chats)).chats]) |> Repo.update 
Ecto.Changeset.put_change(Ecto.Changeset.change(Repo.get_by(Chat, name: [to, from])) , :history,  Repo.get_by(Chat, name: [to, from]).history ++ [["#{Repo.get_by(User, name: from).name}", mes]]) |> Repo.update  
Notice.mes(to, from, mes)
{:ok, Repo.preload(Repo.get_by(Chat, name: [to, from] ), :users).history}
else
Ecto.Changeset.put_change(Ecto.Changeset.change(Repo.get_by(Chat, name: [from, to])) , :history,  Repo.get_by(Chat, name: [from, to]).history ++ [["#{Repo.get_by(User, name: from).name}", mes]]) |> Repo.update  
Notice.mes(to, from, mes)
{:ok, Repo.preload(Repo.get_by(Chat, name: [from, to] ), :users).history}
end
else
Ecto.Changeset.put_change(Ecto.Changeset.change(Repo.get_by(Chat, name: [to, from])) , :history,  Repo.get_by(Chat, name: [to, from]).history ++ [["#{Repo.get_by(User, name: from).name}", mes]]) |> Repo.update  
Notice.mes(to, from, mes)
{:ok, Repo.preload(Repo.get_by(Chat, name: [to, from] ), :users).history}
end  
else {:ok, [["Вход не выполнен"]]}
end
else {:ok, [["Пользователя #{from} не существует"]]}
end
else {:ok, [["Пользователя #{to} не существует"]]}
end
end






end


