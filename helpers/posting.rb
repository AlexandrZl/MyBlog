require 'sinatra/base'

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
end 