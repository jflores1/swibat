class AssociateVideosToLessons < ActiveRecord::Migration
  def change
    add_column :videos, :lesson_id, :integer
    add_column :videos, :user_id, :integer
  end
end
