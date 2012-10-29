class AddPriorKnowledgeToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :prior_knowledge, :string
  end
end
