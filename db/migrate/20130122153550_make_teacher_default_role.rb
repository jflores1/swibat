class MakeTeacherDefaultRole < ActiveRecord::Migration
  def change
    change_column :users, :role, :string, default: "teacher"
  end

end
