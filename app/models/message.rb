class Message < ActiveRecord::Base

	validates_presence_of :text
	validates_presence_of :subject

	belongs_to :user

	has_many :users

	def set_user(user)
		self.user=user
		self.save
	end	

end