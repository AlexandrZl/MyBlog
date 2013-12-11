require 'sinatra/base'

module Sign
  @@salt='ruby'
  def signin
  	password = Digest::SHA2.hexdigest(params[:password] + @@salt)
    user = User.find_by(email: params[:email], password: password)
      if user    
        session[:name] = user.name
        session[:email]= user.email
        session[:user_id] = user.id
        session[:all]  = user, password
        redirect '/'
      end
    redirect '/'
  end

  def signup
  	unless @user || params[:password] != params[:password_second] || params[:password].empty? || flash[:error_email]
      hash = Digest::SHA2.hexdigest(params[:password] + @@salt)
      @user = User.new(name: params[:name], :password => hash, email: params[:email])
      if @user.save
        redirect '/enter'
      else
        redirect '/reg'
      end
    else 
      redirect '/reg'
    end
  end
end