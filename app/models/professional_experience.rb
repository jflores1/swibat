# == Schema Information
#
# Table name: professional_experiences
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  location         :string(255)
#  description      :text
#  still_work       :boolean          default(FALSE)
#  work_start_month :string(255)
#  work_start_year  :integer
#  work_end_month   :string(255)
#  work_end_year    :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ProfessionalExperience < ActiveRecord::Base
  attr_accessible :description, :location, :still_work, :title, :work_end_month, :work_end_year, :work_start_month, :work_start_year
end
