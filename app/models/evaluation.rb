class Evaluation < ActiveRecord::Base
  attr_accessible :evaluation_template_id, :teacher_id

  belongs_to :teacher, class_name: :User
  belongs_to :evaluation_template
end
