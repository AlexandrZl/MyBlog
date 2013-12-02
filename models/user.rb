class User < ActiveRecord::Base
	validates :name,  presence: true
	validates :email, presence: true, uniqueness: true, length: {minimum: 6}
	validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
	validates :password, length: {minimum: 6}, presence: true
	has_many :posts, :dependent => :destroy
end