class User < ActiveRecord::Base
    validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
    validates :name, presence: true
    validates :password, presence: true , length: { minimum: 6 }
	has_many :posts, :dependent => :destroy
end

