class Project < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, :dependent => :destroy

  attr_accessible :name, :description, :user_id

  validates :name, :uniqueness => true, :presence => true

end
