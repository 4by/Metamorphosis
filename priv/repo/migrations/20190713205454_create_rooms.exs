defmodule Repo.Migrations.CreateChats do
use Ecto.Migration

def change do
create table(:chats) do
add :name, {:array, :string} 
add :history, {:array, {:array, :string}} 


end

end
end
