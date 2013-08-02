class Technology < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :ships
  has_many :user_technologies
  has_many :users, :through => :user_technologies

  #has_many :technology_requires
  has_many :relations_from, :class_name => "TechnologyRequire", :foreign_key => "pre_tech_id"
  has_many :relations_to, :class_name => "TechnologyRequire", :foreign_key => "tech_id"
  has_many :linked_from, :through => :relations_to, :source => :pre_tech
  has_many :linked_to, :through => :relations_from, :source => :tech


  #Updated die TechnolgieStufe des Users user
  def upgrade_technology(user)

    if TechnologyRequire.technology_require?(user, self.id)

      result = user_technologies.where(:user_id => user).first
      new_rank = 1

      if !result.blank? then
        new_rank = result.rank + 1
        result.update_attribute(:rank, new_rank)
      else
        user_technologies.create(:rank => 1, :user_id => user)
      end

      #Update UserSettings
      self.update_usersettings(user, new_rank)

    end
  end

  def get_technology_cost(user)

      result = user_technologies.where(:user_id => user).first


    if !result.blank? then
      return  result.rank * self.cost

    else
       return self.cost
    end
  end


  #def update_usersettings(user, rank)

    #TODO UserSetting innitiallisieren beim anlegen
   # record = UserSetting.find(user)
    #record.update_attribute(self.name, self.factor*rank)

  #end


end
