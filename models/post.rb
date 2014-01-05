class Post < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 3 },
            format: { with:  /[\w]/, 
              message: "only allows letters"}
  validates :body, presence: true, format: { with:  /[\w]/, 
              message: "only allows letters"}
  belongs_to :user
  has_many :comments, :dependent => :destroy
  
  def user_name
  	user.name
  end
end