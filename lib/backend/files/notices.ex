defmodule Notice do

use Ecto.Schema
import Ecto.Changeset

schema "notices" do
field :like, {:array, {:array, :string}}, default: []
field :friend, {:array, {:array, :string}}, default: []
field :mes, {:array, {:array, :string}}, default: []
belongs_to :user, User
end



def like(to, from, note) do
if  Enum.any?(Notice |> Repo.all, fn(x) -> x.user_id == Repo.get_by(User, name: to).id end) do #есть ли нотис
Ecto.Changeset.put_change(Ecto.Changeset.change(Repo.get_by(Notice, user_id:  Repo.get_by(User, name: to).id)) , :like,  Repo.get_by(Notice, user_id:  Repo.get_by(User, name: to).id).like ++ [[from, note]]) |> Repo.update 
else #нет нотиса
Notice.changeset(%Notice{}, %{like: [], user_id: Repo.get_by(User, name: to).id}) |> Repo.insert 
Ecto.Changeset.put_change(Ecto.Changeset.change(Repo.get_by(Notice, user_id:  Repo.get_by(User, name: to).id)) , :like,  Repo.get_by(Notice, user_id:  Repo.get_by(User, name: to).id).like ++ [[from, note]]) |> Repo.update 
end
end


def mes(to, from, note) do
if  Enum.any?(Notice |> Repo.all, fn(x) -> x.user_id == Repo.get_by(User, name: to).id end) do #есть ли нотис
Ecto.Changeset.put_change(Ecto.Changeset.change(Repo.get_by(Notice, user_id:  Repo.get_by(User, name: to).id)) , :mes,  Repo.get_by(Notice, user_id:  Repo.get_by(User, name: to).id).mes ++ [[from, note]]) |> Repo.update 
else #нет нотиса
Notice.changeset(%Notice{}, %{mes: [], user_id: Repo.get_by(User, name: to).id}) |> Repo.insert 
Ecto.Changeset.put_change(Ecto.Changeset.change(Repo.get_by(Notice, user_id:  Repo.get_by(User, name: to).id)) , :mes,  Repo.get_by(Notice, user_id:  Repo.get_by(User, name: to).id).mes ++ [[from, note]]) |> Repo.update 

end
end

def friend(to, from, note) do
if  Enum.any?(Notice |> Repo.all, fn(x) -> x.user_id == Repo.get_by(User, name: to).id end) do #есть ли нотис
Ecto.Changeset.put_change(Ecto.Changeset.change(Repo.get_by(Notice, user_id:  Repo.get_by(User, name: to).id)) , :friend,  Repo.get_by(Notice, user_id:  Repo.get_by(User, name: to).id).friend ++ [[from, note]]) |> Repo.update 
else #нет нотиса
Notice.changeset(%Notice{}, %{friend: [], user_id: Repo.get_by(User, name: to).id}) |> Repo.insert 
Ecto.Changeset.put_change(Ecto.Changeset.change(Repo.get_by(Notice, user_id:  Repo.get_by(User, name: to).id)) , :friend,  Repo.get_by(Notice, user_id:  Repo.get_by(User, name: to).id).friend ++ [[from, note]]) |> Repo.update 

end
end

def see(name) do
if Enum.any?(User |> Repo.all, fn(x) -> x.name == name end) do
if Enum.any?(Notice |> Repo.all, fn(x) -> x.user_id == Repo.get_by(User, name: name).id end) do 
%{name: name, requests: Repo.get_by(Notice, user_id: (Repo.get_by(User, name: name).id)).friend,
messages: Repo.get_by(Notice, user_id: (Repo.get_by(User, name: name).id)).mes,
likes: Repo.get_by(Notice, user_id: (Repo.get_by(User, name: name).id)).like}
else
Notice.changeset(%Notice{}, %{friend: [], user_id: Repo.get_by(User, name: name).id}) |> Repo.insert 
%{name: name, requests: Repo.get_by(Notice, user_id: (Repo.get_by(User, name: name).id)).friend,
messages: Repo.get_by(Notice, user_id: (Repo.get_by(User, name: name).id)).mes,
likes: Repo.get_by(Notice, user_id: (Repo.get_by(User, name: name).id)).like}
end
else
%{name: "Пользователя не существует ", requests: [], messages: [], likes: []}  
end
end

def changeset(notice, attrs \\ %{}) do
notice
|> cast(attrs, ~w[like mes friend user_id]a)
|> validate_required(~w[user_id]a)
#  |> assoc_constraint(:user)  #проверяем, что такой овнер есть
end


end