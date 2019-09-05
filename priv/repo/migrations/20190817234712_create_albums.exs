defmodule Repo.Migrations.CreateAlbums do
use Ecto.Migration

def change do
create table(:albums) do
add :name, :string
add :user_id, references(:users)
end
end
end