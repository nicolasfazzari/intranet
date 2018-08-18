class Department < ActiveRecord::Base
	has_many :documentations
	has_many :indicators
end
