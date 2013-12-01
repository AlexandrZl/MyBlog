class User < ActiveRecord::Base
	validates :name, :email, presence: true
	validates :password, :length => {:minimum => 6}, :presence => true
	has_many :posts, :dependent => :destroy
end