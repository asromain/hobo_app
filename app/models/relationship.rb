class Relationship < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    follower_id :integer
    followed_id :integer
    timestamps
  end
  attr_accessible :follower_id, :followed_id

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
