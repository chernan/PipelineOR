class Status < ActiveRecord::Base

has_many :pipeline
has_many :pipeline_item

end
