class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :expenses, dependent: :destroy
  accepts_nested_attributes_for :expenses
  validates :email, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: { 
    regular: 0,
    admin: 1,
  }
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :regular 
  end

end
