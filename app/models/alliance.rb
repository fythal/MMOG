class Alliance < ActiveRecord::Base
	
	validates_presence_of :name

	has_many :ranks

	has_many :users

	validate :is_alliance_name_taken

#checks if alliance name is already taken
	def is_alliance_name_taken
		if Alliance.exists?(:name.downcase => name.downcase)
			errors.add :name, "is already taken"
		end
	end		
end
