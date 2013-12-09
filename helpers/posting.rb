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

  def valid 
    flash.clear
    flash[:name]  = params[:name]
    flash[:email] = params[:email]
    flash[:error_email] = 'Check your email' if params[:email].empty?
    flash[:error_email] = 'wgong your email' unless params[:email].match EMAIL_REGEX
    flash[:error_name]  = 'Check your name'  if params[:name].empty?
    flash[:error_password] = 'Check your password' if  params[:password].empty? || params[:password_second].empty? || params[:password] != params[:password_second]
    flash[:error_email] = 'User with such email already exists' if @user

  end
end 