require "sinatra"
require "sinatra/activerecord"
require_relative './helpers/posting'
helpers Posting

set :database, "sqlite3:///blog.db"

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
  @comm = Comment.new(params[:comm])
  if @comm.save
    redirect '/'
  else
   redirect '/about'
  end
end


post "/posts" do
  @post = Post.new(params[:post])
  if @post.save
    redirect "posts/#{@post.id}"
  else
    erb :"posts/new"
  end
end
 

get "/posts/:id" do
  @post = Post.find(params[:id])
  @title = @post.title
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


delete "/posts/:id" do
  @post = Post.find(params[:id]).destroy
  redirect "/"
end


get "/about" do
  @title = "About Me"
  erb :"pages/about"
end


post '/signup' do
  session[:name]     = params[:username]
  session[:password] = params[:password]
  session[:email]    = params[:email]
  session[:foo]      = session[:name], session[:password], session[:email]
  @user = User.new(name: params[:username], password: params[:password], email: params[:email])
  unless session[:name] == User.find_by(name: session[:name])
    if @user.save
      redirect "/"
    else
    redirect '/notaunt'
    end
  else 
    redirect '/notaunt'
  end
end


post '/signin' do
  session[:name]=params[:name]
  session[:password]=params[:password]
  user = User.find_by(name: session[:name], password: session[:password])
  unless user==nil #session[:name] == User.where(name: session[:name])
    session[:foo] = session[:name], session[:password]
    redirect "/"
  else 
    redirect "/notaunt"
  end
end


get '/notaunt' do
  erb :error
end


get "/reg" do
  @title='Sign up'
  erb :register      
end


post '/logout' do
  session.clear
  redirect '/'
end 


