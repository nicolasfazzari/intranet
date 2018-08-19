class Indicator < ActiveRecord::Base
	self.inheritance_column = :foo
	belongs_to :category
	belongs_to :department
	belongs_to :user
	validates :category, presence: true
	validates :name, presence: true
	validates :data, presence: true
	acts_as_list

end
