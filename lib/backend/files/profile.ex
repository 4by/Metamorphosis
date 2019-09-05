defmodule Profile do
import Ecto.Query

defmodule Add do
def avatar(name, avatar) do
if Repo.get_by(User, name: name).online == true do
try do
User.changeset(Repo.get_by(User, name: name), %{avatar: avatar}) |> Repo.update
{:ok, "Успешно"}
rescue
FunctionClauseError -> {:ok, "Такого пользователя нет"}
end
else {:ok, "Вход не был выполнен"}
end
end

def email(name, email) do
if Repo.get_by(User, name: name).online == true do

try do
User.changeset(Repo.get_by(User, name: name), %{email: email}) |> Repo.update
{:ok, "Успешно"}
rescue
FunctionClauseError -> {:ok, "Такого пользователя нет"}
end
else {:ok, "Вход не был выполнен"}
end
end

def age(name, age) do
if Repo.get_by(User, name: name).online == true do

try do
User.changeset(Repo.get_by(User, name: name), %{age: age}) |> Repo.update
{:ok, "Успешно"}
rescue
FunctionClauseError -> {:ok, "Такого пользователя нет"}
end
else {:ok, "Вход не был выполнен"}
end
end

end        

def show(name) do
if Enum.any?(User |> Repo.all, fn(x) -> x.name == name end) do
h = Repo.get_by(User, name: name).avatar   
g = Repo.get_by(User, name: name).online
a = Repo.get_by(User, name: name).id
b = Repo.get_by(User, name: name).name
c = Repo.get_by(User, name: name).age
d = Repo.get_by(User, name: name).email
f = Enum.map(((Repo.get_by(User, name: name) |> Repo.preload(:friends)).friends), fn(x) -> if x.text == Repo.get_by(User, name: x.text).name, do: x.text end)
try do
e = Photo.albums(name)
profile = %{online: g, id: a, name: b, age: c, email: d, photo_albums: e, friends: f, avatar: h}
rescue
ArgumentError -> e = []
profile = %{online: g, id: a, name: b, age: c, email: d, photo_albums: e, friends: f, avatar: h}
end
else profile = %{online: [], id: [], name: ["Пользователя не существует"], age: [], email: [], photo_albums: [], friends: [], avatar: []}
end 
end


def search(name) do
a = String.codepoints(name)
b = Repo.all(Ecto.Query.from m in User, select: m.name) #база со всеми именами
Enum.filter(b, fn(x) -> String.codepoints(x) |> Enum.take(String.length(name))  == String.codepoints(name) end)
end



end