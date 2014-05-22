class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  fields do
    name          :string, :required, :unique
    email_address :email_address, :login => true
    administrator :boolean, :default => false
    timestamps
  end
  attr_accessible :name, :email_address, :password, :password_confirmation, :current_password, :microposts, :relationship
  has_many :microposts, inverse_of: :user, accessible: true
  has_many :relationships, inverse_of: :follower, foreign_key: "follower_id", dependent: :destroy
  has_many :followers, inverse_of: :relationships, through: :reverse_relationships, source: :follower, accessible: true
  has_many :reverse_relationships, inverse_of: :followed, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followed_users, inverse_of: :relationships, through: :relationships, source: :followed, accessible: true

  # This gives admin rights and an :active state to the first sign-up.
  # Just remove it if you don't want that
  before_create do |user|
    if !Rails.env.test? && user.class.count == 0
      user.administrator = true
      user.state = "active"
    end
  end


  # --- Signup lifecycle --- #

  lifecycle do

    state :active, :default => true

    create :signup, :available_to => "Guest",
           :params => [:name, :email_address, :password, :password_confirmation],
           :become => :active

    transition :request_password_reset, { :active => :active }, :new_key => true do
      UserMailer.forgot_password(self, lifecycle.key).deliver
    end

    transition :reset_password, { :active => :active }, :available_to => :key_holder,
               :params => [ :password, :password_confirmation ]

  end

  # --- Permissions --- #

  def create_permitted?
    # Only the initial admin user can be created
    self.class.count == 0
  end

  def update_permitted?
    acting_user.administrator? ||
      (acting_user == self && only_changed?(:email_address, :crypted_password,
                                            :current_password, :password, :password_confirmation))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end
end
