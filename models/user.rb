class User < ActiveRecord::Base
	validates :name, :email, presence: true
    validates :password, presence: true, length: { in: 6..20}
	has_many :posts, :dependent => :destroy
end