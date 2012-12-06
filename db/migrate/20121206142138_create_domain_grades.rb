class CreateDomainGrades < ActiveRecord::Migration
  def change
    create_table :domain_grades do |t|
    	t.belongs_to :educational_domain
    	t.belongs_to :grade
      t.timestamps
    end
  end
end
