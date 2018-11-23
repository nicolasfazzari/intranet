class Indicator < ActiveRecord::Base
	self.inheritance_column = :foo
	belongs_to :category
	belongs_to :department
	belongs_to :user
	validates :department, presence: true
	validates :name, presence: true
	validates :data, presence: true
	acts_as_list
	acts_as_taggable
	acts_as_taggable_on :tag_list


end
