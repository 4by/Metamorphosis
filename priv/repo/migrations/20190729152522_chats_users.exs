defmodule Backend.Repo.Migrations.CreateChatsUsersTable do
    use Ecto.Migration
    def change do
    create table(:chats_users) do
    add :chat_id, references(:chats)
    add :user_id, references(:users)
    end
    create unique_index(:chats_users, [:chat_id, :user_id])
    end
    end