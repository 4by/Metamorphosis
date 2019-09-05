defmodule Friend do
use Ecto.Schema
import Ecto.Changeset

schema "friends" do
field :text, :string
many_to_many :users, User, join_through: "users_friends", on_delete: :delete_all 
end

def changeset(user, attrs \\ %{}) do
user
|> cast(attrs, ~w[text]a)
|> validate_required(~w[text]a)
#   |> assoc_constraint(:user)  #проверяем, что такой овнер есть
end



def on(to, from, ask) do 
if Repo.get_by(User, name: from).online == true do
if (Enum.any?(User |> Repo.all, fn(x) -> x.name == to end) and Enum.any?(User |> Repo.all, fn(x) -> x.name == to end)) do
if Enum.any?((User |> Repo.all |> Repo.preload(:friends)), fn(x) ->         Enum.any?(   (Repo.get_by(User, name: to) |> Repo.preload(:friends)).friends, fn(x) -> x.text == from end)  end) do
{:ok, "Уже есть такой друг"}
else
if Enum.any?((User |> Repo.all |> Repo.preload(:friends)), fn(x) ->         Enum.any?(   (Repo.get_by(User, name: to) |> Repo.preload(:friends)).friends, fn(x) -> x.text == "Запрос в друзья от #{from} к #{to}" end)  end) do
Repo.get_by(Friend, text: "Запрос в друзья от #{from} к #{to}" ) |> Repo.delete
{:ok, "Запрос отменен"}
else
{:ok, b} = Friend.changeset(%Friend{}, %{text: "Запрос в друзья от #{from} к #{to}"}) |> Repo.insert()
a = Ecto.Changeset.change(Repo.get_by(User, name: to) |> Repo.preload(:friends))
Ecto.Changeset.put_assoc(a, :friends, [b| (Repo.get_by(User, name: to) |> Repo.preload(:friends)).friends  ]) |> Repo.update
Notice.friend(to, from, "Пользователь #{from} хочет добавить пользователя #{to}, прикрепив к запросу сообщение: #{ask}")
{:ok, "Запрос отправлен"}
end
end
else {:ok, "Одного из пользователей не существует"}
end
else {:ok, "Пользователь не авторизован"}
end
end




def new(to, from) do
if Repo.get_by(User, name: to).online == true do
if (Enum.any?(User |> Repo.all, fn(x) -> x.name == to end) and Enum.any?(User |> Repo.all, fn(x) -> x.name == to end)) do
if Enum.any?((Repo.get_by(User, name: to) |> Repo.preload(:friends)).friends, fn(x) -> x.text == "Запрос в друзья от #{from} к #{to}" end) do
if Enum.any?(Friend |> Repo.all, fn(x) -> x.text == from end) do  #ЕСТЬ ЛИ ОТПРАВИВШИЙ ЗАПРОС В ДРУЗЬЯХ


#УДАЛЕНИЕ И ДОБАВЛЕНИЕ


Repo.get_by(Friend, text: "Запрос в друзья от #{from} к #{to}") |> Repo.delete
b = Repo.get_by(Friend, text: from)
a = Ecto.Changeset.change(Repo.get_by(User, name: to) |> Repo.preload(:friends))
Ecto.Changeset.put_assoc(a, :friends, [b| (Repo.get_by(User, name: to) |> Repo.preload(:friends)).friends  ]) |> Repo.update
Notice.friend(from, to, "Пользователь #{to} добавил пользователя #{from}")
if Enum.any?(Friend |> Repo.all, fn(x) -> x.text == to end) do 
b = Repo.get_by(Friend, text: to)
a = Ecto.Changeset.change(Repo.get_by(User, name: from) |> Repo.preload(:friends))
Ecto.Changeset.put_assoc(a, :friends, [b| (Repo.get_by(User, name: from) |> Repo.preload(:friends)).friends  ]) |> Repo.update
{:ok, "Добавление прошло успешно"}
else
{:ok, b} = Friend.changeset(%Friend{}, %{text: to}) |> Repo.insert()
a = Ecto.Changeset.change(Repo.get_by(User, name: from) |> Repo.preload(:friends))
Ecto.Changeset.put_assoc(a, :friends, [b| (Repo.get_by(User, name: from) |> Repo.preload(:friends)).friends  ]) |> Repo.update
{:ok, "Добавление прошло успешно"}
end

#ПЕРЕИМЕНОВКА
#ЗДЕСЬ ТУХА НЕ НУЖНА

else
a = Ecto.Changeset.change(Repo.get_by(Friend, text: "Запрос в друзья от #{from} к #{to}"))
b = from
Ecto.Changeset.put_change(a, :text, b) |> Repo.update
Notice.friend(from, to, "Пользователь #{to} добавил пользователя #{from}")
if Enum.any?(Friend |> Repo.all, fn(x) -> x.text == to end) do 
b = Repo.get_by(Friend, text: to)
a = Ecto.Changeset.change(Repo.get_by(User, name: from) |> Repo.preload(:friends))
Ecto.Changeset.put_assoc(a, :friends, [b| (Repo.get_by(User, name: from) |> Repo.preload(:friends)).friends  ]) |> Repo.update
{:ok, "Добавление прошло успешно"}
else
{:ok, b} = Friend.changeset(%Friend{}, %{text: to}) |> Repo.insert()
a = Ecto.Changeset.change(Repo.get_by(User, name: from) |> Repo.preload(:friends))
Ecto.Changeset.put_assoc(a, :friends, [b| (Repo.get_by(User, name: from) |> Repo.preload(:friends)).friends  ]) |> Repo.update
{:ok, "Добавление прошло успешно"}
end
end
else {:ok, "Нет запроса"}
end
else {:ok, "Одного из пользователей не существует"}
end
else {:ok, "Пользователь не авторизован"}
end
end

def off(to, from) do
 if Repo.get_by(User, name: to).online == true do
if (Enum.any?(User |> Repo.all, fn(x) -> x.name == to end) and Enum.any?(User |> Repo.all, fn(x) -> x.name == to end)) do 
if Enum.any?((User |> Repo.all |> Repo.preload(:friends)), fn(x) ->         Enum.any?(   (Repo.get_by(User, name: to) |> Repo.preload(:friends)).friends, fn(x) -> x.text == from end)  end) do

a = Ecto.Changeset.change(Repo.get_by(User, name: to) |> Repo.preload(:friends))
b = Enum.filter((Repo.get_by(User, name: to) |> Repo.preload(:friends)).friends, fn(x) -> x.text != from end)
Ecto.Changeset.put_assoc(a, :friends, b) |> Repo.update 

a = Ecto.Changeset.change(Repo.get_by(User, name: from) |> Repo.preload(:friends))
b = Enum.filter((Repo.get_by(User, name: from) |> Repo.preload(:friends)).friends, fn(x) -> x.text != to end)
Ecto.Changeset.put_assoc(a, :friends, b) |> Repo.update 
{:ok, "Удаление прошло успешно"}
else {:ok, "Пользователи не являются друзьями"}
end
else {:ok, "Одного из пользователей не существует"}
end
else {:ok, "Пользователь не авторизован"}
end
end


end
