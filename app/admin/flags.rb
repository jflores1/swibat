ActiveAdmin.register Flag do

	index do 
		column :id
		column :flaggable
		column :flaggable_type
		column "Flagged at", :created_at
		column "Flagged by", :user
		default_actions
	end

	show do |flag|
    attributes_table do      
    	row :id
    	row :flaggable_id
    	row :flaggable_type
    	row :created_at
    	row :user
    end
    active_admin_comments
  end

end
