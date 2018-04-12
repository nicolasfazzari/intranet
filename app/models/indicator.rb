class Indicator < ActiveRecord::Base
	self.inheritance_column = :foo
	belongs_to :category
	validates :category, presence: true
	validates :name, presence: true
	validates :data, presence: true
	acts_as_list

end
