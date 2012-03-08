class Script < ActiveRecord::Base

has_many :input_outputs
has_many :pipeline_items

end
