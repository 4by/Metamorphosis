defmodule Resolvers do
    import Ecto.Query, only: [from: 2]
    alias BackendWeb.Endpoint
    
    
    def notices(%{name: pam2}, _) do
    {:ok, notice}  = {:ok, [List.last(Notice.see(pam2).messages)] } 
    Absinthe.Subscription.publish(Endpoint, notice, vtoraya: pam2)
    {:ok, Notice.see(pam2)}  
    end
    
    
    
    def mes(%{room: pam, user: user, mes: mes}, _) do
    {:ok, chat}  = {:ok,  Chat.mes(pam, user, mes)} 
    if chat != [["Пользователь не находится в комнате"]] and chat != [["Комната не была создана"]] and chat != [["Вход не выполнен"]] do
    Absinthe.Subscription.publish(Endpoint, chat, vtoraya: pam)
    {:ok, chat}
    else
    {:ok, chat}  
    end
    end
    #def mes(%{room: room, user: user, mes: mes}, _) do
    #Chat.mes(room, user, mes)
    #end
    
    
    def profile(%{name: pam}, _) do       
    {:ok, profile}  = {:ok, Profile.show(pam)} 
    Absinthe.Subscription.publish(Endpoint, profile, pervaya: pam) #отправили ключ для сабскрипшна их схемы юзер
    {:ok, profile}
    end
    #def profile(%{name: name}, _) do
    #{:ok, Profile.show(name)} 
    #end
    
    
    
    def ls(%{to: to, from: from, mes: mes}, _) do
    Chat.ls(to, from, mes)
    end
    
    
    def albumr(%{user: user, alb: alb}, _) do
    Photo.albumr(user, alb)
    end
    
    
    def photor(%{user: user, alb: alb, photo: photo}, _) do
    Photo.photor(user, alb, photo)
    end
    
    def rooms(_, _) do
    {:ok, Chat.rooms}
    end
    
    def room_info(%{room: room}, _) do
    {:ok, Chat.see(room)}
    end
    
    def notices(%{name: name}, _) do
    {:ok, Notice.see(name)}
    end
    
    
    def out(%{room: room, name: name,}, _) do
    Chat.out(room, name)
    end
    
    def add(%{room: room, name: name,}, _) do
    Chat.add(room, name)
    end
    
    def roomr(%{room: room}, _) do
    Chat.roomr(room)
    end
    
    
    
    def room(%{room: room}, _) do
    Chat.room(room)
    end
    
    
    def photo_like(%{to: to, from: from, alb: alb, photo: photo}, _) do
    Photo.like(to, from, alb, photo)
    end
    
    
    def photos(%{user: user, alb: alb}, _) do
    {:ok, Photo.photos(user, alb)}
    
    end
    
    
    def albums(%{user: user}, _) do
    {:ok, Photo.albums(user)}
    end
    
    def photo(%{user: user, alb: alb, name: name}, _) do
    Photo.photo(user, alb, name)
    end
    
    
    def album(%{user: user, alb: alb}, _) do
    Photo.album(user, alb)
    end
    
    
    def email(%{name: name, email: email}, _) do
    Profile.Add.email(name, email)
    end
    
    
    def age(%{name: name, age: age}, _) do
    Profile.Add.age(name, age)
    end
    
    
    def avatar(%{name: name, avatar: avatar}, _) do
    Profile.Add.avatar(name, avatar)
    end
    
    def search(%{name: name}, _) do
    {:ok, Profile.search(name)} 
    end
    
    
    def unfriend(%{login1: login1, login2: login2}, _) do
    Friend.off(login1, login2)
    end
    
    
    def accept(%{login1: login1, login2: login2}, _) do
    Friend.new(login1, login2)
    end
    
    def request(%{login1: login1, login2: login2, ask: ask}, _) do
    Friend.on(login1, login2, ask)
    end
    
    def logout(%{name: name}, _) do
    User.off(name)
    end
    
    
    def auth(%{name: name, password: password}, _) do
    User.on(name, password)
    end
    
    def reg(%{name: name, password: password}, _) do
    User.new(name, password)
    end
    
    
    
    
    end