class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class User < ActiveRecord::Base
	validates :name,  presence: true
	validates :email, presence: true, uniqueness: true, length: {minimum: 6}, email: true
	validates :password, length: {minimum: 6}, presence: true
	has_many :posts, :dependent => :destroy
end

