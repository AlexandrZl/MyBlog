require "sinatra"
require 'rubygems'
require "sinatra/activerecord"
require 'sinatra/flash'
require "digest/sha2"

Dir.foreach('models/') { |model| require "./models/#{model}" if model.match /.rb$/ }
Dir.foreach('./helpers/') { |model| require_relative "./helpers/#{model}" if model.match /.rb$/ }
helpers Posting, Validation, Sign

ActiveRecord::Base.establish_connection(
  adapter: postgresql
  encoding: unicode
  pool: 5
  database: dg0aiarns08uq
  username: igswxxjndlzspv
  password: G6kp8PcdFphLzRPAqX4hww6D19
  host: ec2-54-204-43-139.compute-1.amazonaws.com
  port: 5432)


configure do
  enable :sessions
  set :session_secret, 'secret'
end


get "/" do
  @posts = Post.order("created_at DESC")
  erb :"posts/index"
end


get "/posts/new" do
  @title = "New Post"
  @post = Post.new
  erb :"posts/new"
end


post "/posts/:id/create_comment" do
  @post = Post.find(params[:id])
  valid_comment
  @comm = Comment.new(title: params[:title],
                      body: params[:body],
                      post_id: params[:id],
                      user_name: session[:name],
                      user_id: session[:user_id])
  @comm.save
  redirect "/posts/#{@post.id}"
end


post "/posts" do  
  valid_post
  user_id = session[:user_id]
  @post = Post.new(title: params[:title], body: params[:body], user_id: user_id)
  if @post.save
    redirect "posts/#{@post.id}"
  else
    redirect '/posts/new'
  end
end
 

get "/posts/:id" do
  @post = Post.find(params[:id])
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


delete "/posts/:id/comment/:id_comment" do
  @post = Post.find(params[:id])  
  if author? @post
    @comm = Comment.find(params[:id_comment]).destroy
    redirect "/posts/#{params[:id]}"
  end
end


delete "/posts/:id" do
  @post = Post.find(params[:id])  
  if author? @post 
    @post.destroy
    redirect "/"
  end
end


get "/about" do
  @title = "About Me"
  erb :"pages/about"
end


post '/signup' do
  @user=User.find_by_email(params[:email]) 
  valid_signup
  signup
end


post '/signin' do 
  valid_signin
  signin
end


get '/enter' do
  erb :"registration/enter"
end


get "/reg" do
  @title='Sign up'
  erb :"registration/register"      
end


post '/logout' do
  session.clear
  redirect '/'
end 