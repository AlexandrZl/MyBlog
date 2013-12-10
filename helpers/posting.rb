require 'sinatra/base'
EMAIL_REGEX =  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

module Posting
  def title
    if @title
      "#{@title} -- My Blog"
    else
      "My Blog"
    end
  end

  def pretty_date(time)
    time.strftime("%d %b %Y")
  end

  def post_show_page?
    request.path_info =~ /\/posts\/\d+$/
  end

  def delete_post_button(post_id)
    erb :"posts/_delete_post_button", locals: { post_id: post_id }
  end

  def delete_comment_button(comment_id)
    if author? @post
      erb :"posts/_delete_comment_button", locals: { comment_id: comment_id}
    end
  end

  def author? post
    post.user == User.find_by(email: session[:email])
  end

  def valid_signup
    flash.clear
    flash[:name]  = params[:name]
    flash[:email] = params[:email]
    flash[:error_email] = 'Check your email' if params[:email].empty?
    flash[:error_email] = 'Wrong your email' unless params[:email].match EMAIL_REGEX
    flash[:error_name]  = 'Check your name'  if params[:name].empty?
    flash[:error_password] = 'Check your password' if  params[:password].empty? || params[:password_second].empty? || params[:password] != params[:password_second]
    flash[:error_email] = 'User with such email already exists' if @user
  end

  def valid_post
    flash.clear
    flash[:error_title] = 'Check your title' if params[:title].empty?
    flash[:error_body]  = 'Check your body'  if params[:body].empty?
  end

  def valid_signin
    flash.clear
    user_check = User.find_by_email(params[:email])
    flash[:error_email] = 'This email is not exists' unless user_check
    flash[:error_email] = 'Wrong email' unless params[:email].match EMAIL_REGEX
    flash[:password]    = 'Check your passwors' if params[:password].empty?
  end
end 