defmodule Repo.Migrations.CreateNotices do
  use Ecto.Migration

  def change do
    create table(:notices) do
      add :like, {:array, {:array, :string}}
      add :friend, {:array, {:array, :string}}
      add :mes, {:array, {:array, :string}}
      add :user_id, references(:users)
  
      end
     
  end
end
