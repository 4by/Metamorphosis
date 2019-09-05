defmodule Photo do
use Ecto.Schema
import Ecto.Changeset

defmodule Album do
use Ecto.Schema
import Ecto.Changeset
schema "albums" do
field :name, :string
belongs_to :user, User
has_many :photos, Photo, on_delete: :delete_all
end
def changeset(user, attrs \\ %{}) do
user
|> cast(attrs, ~w[name user_id]a)
|> validate_required(~w[name]a)
|> assoc_constraint(:user)  #проверяем, что такой овнер есть
end
end


schema "photos" do
field :name, :string
field :like, {:array, {:array, :string}}, default: []
belongs_to :album, Photo.Album
end

def changeset(photo, attrs \\ %{}) do
photo
|> cast(attrs, ~w[name album_id]a)
|> assoc_constraint(:album)  #проверяем, что такой овнер есть
end

def photor(user, alb, photo) do
if Enum.any?(User |> Repo.all, fn(x) -> x.name == user end) do
if Repo.get_by(User, name: user).online == true do
if Enum.any?(Repo.preload(Repo.all(Photo.Album), :photos), fn(x) -> x.name == alb and x.user_id == Repo.get_by(User, name: user).id end) do
if Enum.any?(Repo.preload(Repo.all(Photo), :album), fn(x) -> x.name == photo and x.album_id == Repo.get_by(Photo.Album, name: alb, user_id: Repo.get_by(User, name: user).id ,name: alb).id end) do
Repo.get_by(Photo, name: photo, album_id: Repo.get_by(Photo.Album, name: alb, user_id: Repo.get_by(User, name: user).id ,name: alb).id) |> Repo.delete
{:ok, "Фотография удалена"}
else {:ok, "Такой фотографии не существует"}
end
else {:ok, "Альбома не существует"}
end
else {:ok, "Вход не выполнен"}
end
else {:ok, "Пользователя не существует"}
end
end


def albumr(user, alb) do
if Enum.any?(User |> Repo.all, fn(x) -> x.name == user end) do
if Repo.get_by(User, name: user).online == true do
if Enum.any?(Repo.preload(Repo.all(Photo.Album), :photos), fn(x) -> x.name == alb and x.user_id == Repo.get_by(User, name: user).id end) do
Repo.get_by(Photo.Album, name: alb, user_id: Repo.get_by(User, name: user).id ,name: alb) |> Repo.delete
{:ok, "Альбом удален"}
else {:ok, "Такого альбома не существует"}
end
else {:ok, "Вход не выполнен"}
end
else {:ok, "Пользователя не существует"}
end
end


def like(to, from, alb, photo) do
if Enum.any?(User |> Repo.all, fn(x) -> x.name == to end) do
if Enum.any?(User |> Repo.all, fn(x) -> x.name == from end) do
if Repo.get_by(User, name: from).online == true do
if Enum.any?(Repo.preload(Repo.all(Photo.Album), :photos), fn(x) -> x.name == alb and x.user_id == Repo.get_by(User, name: to).id end) do
if Enum.any?(Repo.preload(Repo.all(Photo), :album), fn(x) -> x.name == photo and x.album_id == Repo.get_by(Photo.Album, name: alb, user_id: Repo.get_by(User, name: to).id ,name: alb).id end) do
case Enum.any?(  Repo.get_by(Photo, name: photo, album_id: (Repo.get_by(Photo.Album, user_id: Repo.get_by(User, name: to).id, name: alb)).id).like  , fn(x) -> Enum.at(x, 0) == from   end) do
true ->
Ecto.Changeset.put_change(Ecto.Changeset.change(Repo.get_by(Photo, album_id: Repo.get_by(Photo.Album, name: alb, user_id: Repo.get_by(User, name: to).id ,name: alb).id, id: Repo.get_by(Photo,  album_id: Repo.get_by(Photo.Album, name: alb, user_id: Repo.get_by(User, name: to).id).id, name: photo).id)) , :like,         Enum.map(  Repo.get_by(Photo, name: photo, album_id: (Repo.get_by(Photo.Album, user_id: Repo.get_by(User, name: to).id, name: alb)).id).like   , fn(x) -> if Enum.at(x, 0) == from do x -- x else x end   end) -- [[]])    |> Repo.update
{:ok, "Лайк удален"}
false ->
Ecto.Changeset.put_change(Ecto.Changeset.change(Repo.get_by(Photo, album_id: Repo.get_by(Photo.Album, name: alb, user_id: Repo.get_by(User, name: to).id ,name: alb).id, id: Repo.get_by(Photo,  album_id: Repo.get_by(Photo.Album, name: alb, user_id: Repo.get_by(User, name: to).id).id, name: photo).id)) , :like, Repo.get_by(Photo, name: photo, album_id: Repo.get_by(Photo.Album, name: alb, user_id: Repo.get_by(User, name: to).id).id).like ++ [[from]] )    |> Repo.update
Notice.like(to, from, "#{alb}/#{photo} ")
{:ok, "Лайк поставлен"}
end
else {:ok, "Такой фотографии не существует в альбоме"}
end
else {:ok, "Такого альбома нет"}
end
else {:ok, "Вход не выполнен"}
end
else {:ok, "Пользователя #{from} не существует"}
end
else {:ok, "Пользователя #{to} не существует"}
end
end

def album(user, alb) do
if Enum.any?(User |> Repo.all, fn(x) -> x.name == user end) do
if Repo.get_by(User, name: user).online == true do
if Enum.any?(Repo.preload(Repo.all(Photo.Album), :photos), fn(x) -> x.name == alb and x.user_id == Repo.get_by(User, name: user).id end) do
{:ok, "Уже есть данный такой альбом у данного пользователя"}
else 
Repo.insert(Photo.Album.changeset(%Photo.Album{}, %{name: alb, user_id: Repo.get_by(User, name: user).id}))
{:ok, "Альбом добавлен"}
end
else {:ok, "Вход не выполнен"}
end
else {:ok, "Такого пользователя не существует"} end
end

def photo(user, alb, name) do
if Enum.any?(User |> Repo.all, fn(x) -> x.name == user end) do
if Repo.get_by(User, name: user).online == true do
if Enum.any?(Repo.preload(Repo.all(Photo.Album), :photos), fn(x) -> x.name == alb and x.user_id == Repo.get_by(User, name: user).id end) do
case Enum.any?((Repo.get_by(Photo.Album, user_id: Repo.get_by(User, name: user).id, name: alb) |> Repo.preload(:photos)).photos, fn(x) -> x.name == name end) do
true -> {:ok, "Уже есть такая фотография в этом альбоме"}
false -> 
Repo.insert(Photo.changeset(%Photo{}, %{name: name, album_id: Repo.get_by(Photo.Album, name: alb, user_id: Repo.get_by(User, name: user).id ).id}))
{:ok, "Фото загружено"}
end
else {:ok, "У пользователя нет данного альбома"}
end
else {:ok, "Вход не выполнен"}
end
else {:ok, "Пользователя не существует"}
end
end

def albums(user) do
if Enum.any?(User |> Repo.all, fn(x) -> x.name == user end) do
Enum.map((Repo.get_by(User, name: user) |> Repo.preload(:albums)).albums, fn(x) -> x.name end)  
else {:ok, "Пользователя не существует"}
end
end


def photos(user, alb) do
if Enum.any?(User |> Repo.all, fn(x) -> x.name == user end) do
if Enum.any?(Repo.preload(Repo.all(Photo.Album), :photos), fn(x) -> x.name == alb and x.user_id == Repo.get_by(User, name: user).id end) do  
(Repo.get_by(Photo.Album, user_id: Repo.get_by(User, name: user).id, name: alb) |> Repo.preload(:photos)).photos
else {:ok, "Такого альбома не существует"}
end
else {:ok, "Пользователя не существует"}
end
end








end
