defmodule Backend.Repo.Migrations.CreateFriendsTable do
  use Ecto.Migration

  def change do
create table(:friends) do
add :text, :string
  end
end
end