class Role < ActiveRecord::Base
  has_many :users

  attr_accessible :name

  validates :name, :uniqueness => true, :presence => true
end
