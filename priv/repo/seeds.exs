# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Backend.Repo.insert!(%Backend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, seller1} = 
Ppl.changeset(%Ppl{}, %{login: "seller1"})
|> Repo.insert()
IO.puts("SELLER1_ID = #{seller1.id}")

{:ok, seller2} = 
Ppl.changeset(%Ppl{}, %{login: "seller2"})
|> Repo.insert()
IO.puts("SELLER2_ID = #{seller2.id}")

{:ok, buyer} = 
Ppl.changeset(%Ppl{}, %{login: "buyer"})
|> Repo.insert()
IO.puts("BUYER_ID = #{buyer.id}")
{:ok, shop1} = 
Shop.changeset(%Shop{}, %{name: "М-Видео", owner_id: seller1.id})
|> Repo.insert()

{:ok, shop2} = 
Shop.changeset(%Shop{}, %{name: "Эльдорадо", owner_id: seller2.id})
|> Repo.insert()

products = [
    %{name: "Мышь", price: "30000", amount: "100", shop_id: shop1.id},
    %{name: "Клавиатура", price: "120000", amount: "50", shop_id: shop1.id},
    %{name: "Холодильник", price: "5000000", amount: "30", shop_id: shop2.id},
    %{name: "Стиральная машина", price: "3000000", amount: "5", shop_id: shop2.id}

]

products |> Enum.each(fn product ->

{:ok, _} = 
Product.changeset(%Product{}, product)
|> Repo.insert()

end)