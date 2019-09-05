defmodule User do
use Ecto.Schema
require Ecto.Query
alias Ecto.Changeset
schema "users" do
field :name, :string
field :email, :string
field :password, :string
field :age, :integer
field :avatar, :string
field :online, :boolean, default: true
has_many :albums, Photo.Album
many_to_many :friends, Friend, join_through: "users_friends", on_replace: :delete 
has_many :notices, Notice
many_to_many :chats, Chat, join_through: "chats_users", on_replace: :delete #это для put_assoc в выходе из комнаты (а в чате он делете в этом месте)
end

def changeset(user,params \\ %{}) do #здесь user - входная функция, а params - то, что разрешено. Указано ниже
user
|> Changeset.cast(params,[:email, :name, :password, :age, :avatar, :online]) #все, что разрешено (иначе будет отброшено)
|> Changeset.validate_required([:name, :password]) #все, что обязательно
|> Changeset.validate_length(:name, min: 3)
end


def new(login, pass) do
try do
(Repo.get_by(User, name: login).name)
{:ok, "Логин занят"}
rescue
UndefinedFunctionError -> 

%User{}
|> User.changeset(%{name: login, password: pass})
|> Repo.insert()
l = %User{} |> User.changeset(%{name: login, password: pass})
if l.valid? do
{:ok, "Регистрация успешна"}
end
end
end


def on(login, pass) do
try do
(Repo.get_by(User, name: login).name)
if ((Repo.get_by(User, name: login).password) == pass) do 
User.changeset(Repo.get_by(User, name: login), %{online: true}) |> Repo.update
{:ok, "Вход выполнен"}
else
{:ok, "Пароль неверен"}
end
rescue
UndefinedFunctionError ->
{:ok, "Такого пользователя нет"}
end
end

def off(login) do
if Repo.get_by(User, name: login).online == true do
User.changeset(Repo.get_by(User, name: login), %{online: false}) |> Repo.update
{:ok, "Выход выполнен"}
else  {:ok, "Вход не был выполнен"} end
end



end




