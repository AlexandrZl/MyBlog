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


post '/login' do
  session[:foo] = params[:username], params[:password], params[:email]
  @user = User.new(:name => params[:username], :password => params[:password], :email => params[:email])
  if @user.save
    redirect "/"
  else
    redirect '/about'
  end
end


post '/sign' do
  session[:foo] = params[:nameuser] , params[:password]
  if session[:foo] == User.where(params[:name],params[:password])
    session[:foo] = params[:nameuser], params[:password]
    redirect "/"
  else 
    session.clear
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


