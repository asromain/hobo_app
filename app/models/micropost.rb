class Micropost < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    content :string
    user_id :integer
    timestamps
  end
  attr_accessible :content, :user_id, :user
  belongs_to :user, inverse_of: :microposts

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
