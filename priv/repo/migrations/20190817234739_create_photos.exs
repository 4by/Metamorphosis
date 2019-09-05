defmodule Repo.Migrations.CreatePhotos do
  use Ecto.Migration
  def change do
  create table(:photos) do
    add :name, :string
    add :like, :map
    add :album_id, references(:albums)

    end
   
  end
  
end
