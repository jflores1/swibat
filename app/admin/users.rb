ActiveAdmin.register User do
	
  show do |user|
    attributes_table do      
    	row :id
    	row :email
    	row :first_name
    	row :last_name
      row :image do
        image_tag(user.image.url(:x100))
      end      
    	row :created_at
    	row :last_sign_in_at
    	row :last_sign_in_ip
    	row :role
    	row :profile_summary
    	row :provider
    	row :uid
    	row :institution
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Details" do
      f.input :email
      f.input :institution
      f.input :first_name
      f.input :last_name
      f.input :role
      f.input :profile_summary
      f.input :provider
      f.input :uid
    end
    f.buttons
  end


  
end
