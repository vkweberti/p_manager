class User < ActiveRecord::Base
  belongs_to :role
  has_many :projects
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :role_id
  # attr_accessible :title, :body

  validates_presence_of :login
  validates_uniqueness_of :login
end
