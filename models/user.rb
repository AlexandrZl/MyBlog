class User < ActiveRecord::Base
    validates :email, presence: true
    validates :name, presence: true
    validates :password, presence: true , length: { minimum: 6 }
	has_many :posts, :dependent => :destroy
end

