class Task < ActiveRecord::Base
  STATUS = {
      :requested => 0,
      :started => 1,
      :stopped => 2,
      :closed => 3
  }

  belongs_to :project

  attr_accessible :name, :description, :project_id, :run_at, :stop_at, :status

  validates_presence_of :name, :project_id

  scope :for_user, lambda{ |user|
    where("tasks.project_id IN (SELECT projects.id FROM projects WHERE projects.user_id = ?)", user.id)
  }
  scope :started, where(:status => STATUS[:started])

  def started?
    self.status == STATUS[:started]
  end

  def stopped?
    self.status == STATUS[:stopped]
  end

  def closed?
    self.status == STATUS[:closed]
  end
end
