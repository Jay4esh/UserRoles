class User < ApplicationRecord
  has_many :users
  before_create :assign_role_name

  def super_admin?
    role == 'super_admin'
  end

  def admin?
    role == 'admin'
  end

  def normal_user?
    role == 'normal_user'
  end

 ROLES = %w[normal_user admin super_admin]

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

end