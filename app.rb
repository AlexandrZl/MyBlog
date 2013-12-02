require "sinatra"
require "sinatra/activerecord"
require "digest/sha2"
require_relative './helpers/posting'
helpers Posting
@@salt='ruby'

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
  if params[:password] == params[:password_second]
    user=User.find_by_email(params[:email]) 
    unless user
      hash = Digest::SHA2.hexdigest(params[:password] + @@salt)
      user = User.new(name: params[:name], :password => hash, email: params[:email])
      if user.save
        redirect '/enter'
      else
        redirect '/reg'
      end
    else
      redirect 'check_email'
    end
  else
    redirect '/reg'
  end
end


post '/signin' do 
  password = Digest::SHA2.hexdigest(params[:password] + @@salt)
  user = User.find_by(email: params[:email], password: password)
  user_check = User.find_by_email(params[:email])
  unless user
    if user_check
      redirect '/check'
    end
  end    
  redirect '/notauth' unless user
  session[:name] = user.name
  session[:email]= user.email
  session[:all]  = user, password
  redirect '/'
end

get '/check_email' do
  erb :exists_email
end

get '/notauth' do
  erb :error
end

get '/enter' do
  erb :enter
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