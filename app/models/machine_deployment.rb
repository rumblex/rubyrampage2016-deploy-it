class MachineDeployment < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :deployment
  belongs_to :machine
  belongs_to :status, class_name: 'DeploymentStatus'

  serialize :roles, Array

  scope :pending, -> { where(status_id: DeploymentStatus::PENDING.id) }

  after_initialize :set_default_status

  validates :deployment_id, :status_id, presence: true

  delegate :name, to: :machine, prefix: true

  def append_to_log(text)
    self.class.where(id: id).update_all(["log = log || ?", text])
  end

  protected

  def set_default_status
    self.status ||= DeploymentStatus::PENDING
  end
end
