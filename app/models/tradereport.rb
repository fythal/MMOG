class Tradereport < ActiveRecord::Base
	has_one :report, as: :reportable

	# modes: 0 = Gegner
	# 		 1 = unbewohnter Planet
	#        2 = Allianzmitglied
	#        3 = eigener Planet
	def finish_tradereport(fleet, planet, mode)
		@r = Report.new
		self.report = @r

		self.mode = mode

		@r.defender = planet.user
		@r.defender_planet = planet

		@r.attacker = fleet.user
		@r.attacker_planet = fleet.start_planet

		@r.receivers << planet.user if !planet.user.nil?
		@r.receivers << fleet.user

		@r.fightdate = Time.at(fleet.arrival_time)

		self.ore = fleet.ore
		self.crystal = fleet.crystal
		self.space_cash = fleet.credit

		self.save
		@r.save
	end
end
