class User < ActiveRecord::Base
	attr_accessor :password_second
	SALT = 'ruby'
    validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, 
              message: "only allows letters"}
    validates :name, presence: true
    validates :password, presence: true , length: { minimum: 6 }
	has_many  :posts, :dependent => :destroy
	validate :check_password
	before_save :hash1

	
	def self.is_persisted? email
		user = User.find_by_email email 
	end

	def check_password
		errors[:password] = 'password does not match' unless password == password_second
	end

	def hash1
	  self.password = Digest::SHA2.hexdigest(password + SALT)
	end

	def hash password
	  Digest::SHA2.hexdigest(password + SALT)
	end
end