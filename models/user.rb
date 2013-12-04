class User < ActiveRecord::Base
	validates :name,  presence: true
	validates :email, presence: true, uniqueness: true, length: {minimum: 6}
	validates :password, length: {minimum: 6}, presence: true
	has_many :posts, :dependent => :destroy
end