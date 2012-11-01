class Project < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :description, :user_id

  validates :name, :uniqueness => true, :presence => true

end
