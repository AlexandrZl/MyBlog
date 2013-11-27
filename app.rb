require "sinatra"
require "sinatra/activerecord"
require_relative './helpers/posting'
helpers Posting

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => './db/blog.sqlite3'
)

configure do
  enable :sessions
  set :session_secret, 'secret'
end

Dir.foreach('models/') { |model| require "./models/#{model}" if model.match /.rb$/ }

get "/" do
  @posts = Post.order("created_at DESC")
  erb :"posts/index"
end


get "/posts/new" do
  @title = "New Post"
  @post = Post.new
  erb :"posts/new"
end


post "/comment" do
  User.all.each do |user|
    if user.name == session[:name]
      @id=user.id
    end
  end
  @comm = Comment.new(title: params[:title], body: params[:body], post_id: session[:id], user_name: session[:name], user_id: @id)
  if @comm.save
    redirect "/posts/#{@comm.post_id}"
  else
    redirect "/"
  end
end


post "/posts" do
  User.all.each do |user|
    if user.name == session[:name]
      @id=user.id
    end
  end
  @post = Post.new(title: params[:title], body: params[:body], user_id: @id)
  if @post.save
    redirect "posts/#{@post.id}"
  else
    erb :"posts/new"
  end
end
 

get "/posts/:id" do
  @post = Post.find(params[:id])
  session[:id] = @post.id
  User.all.each do |user| 
    if session[:name] == user.name  
      @id=user.id
    end 
  end
  erb :"posts/show"
end


get "/posts/:id/edit" do
  @post = Post.find(params[:id])
  @title = "Edit Form"
  erb :"posts/edit"
end
 

put "/posts/:id" do
  @post = Post.find(params[:id])
  if @post.update_attributes(params[:post])
    redirect "/posts/#{@post.id}"
  else
    erb :"posts/edit"
  end
end


delete "/delcom/:id" do
  @comm = Comment.find(params[:id]).destroy
  redirect "/posts/#{@comm.post_id}"
end


delete "/posts/:id" do
  @post = Post.find(params[:id]).destroy
  @post.comments.each do |post| 
    post.delete
  end
  redirect "/"
end


get "/about" do
  @title = "About Me"
  erb :"pages/about"
end


post '/signup' do
  session[:name]     = params[:name]
  session[:password] = params[:password]
  session[:email]    = params[:email]
  unless User.first==nil
    User.all.each do |user|
      if session[:name] == user.name
        @name=user.name
      end
    end
    if session[:name]== @name
      redirect '/exists'
    else
      @user = User.new(name: params[:name], password: params[:password], email: params[:email])
      if @user.save
        session[:all] = session[:name], session[:password], session[:email]
        redirect "/"
      else
        redirect '/notaunt'
      end
    end
  else
    @user = User.new(name: params[:name], password: params[:password], email: params[:email])
    if @user.save
      session[:all] = session[:name], session[:password], session[:email]
      redirect "/"
    else
      redirect '/notaunt'
    end
  end
end


post '/signin' do 
  User.all.each do |user|
    if user.name == params[:name] 
      if user.password == params[:password]
        @user=user.name
        @password=user.password
      else 
        redirect '/check'
      end
    end
  end
  unless @user==nil
    session[:name] = @user
    session[:all] = @user, @password
    redirect "/"
  else 
    redirect "/notaunt"
  end
end


get '/notaunt' do
  erb :error
end


get '/exists' do
  erb :exists
end


get '/check' do
  erb :check
end


get "/reg" do
  @title='Sign up'
  erb :register      
end


post '/logout' do
  session.clear
  redirect '/'
end 