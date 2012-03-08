class PipelineItem < ActiveRecord::Base

belongs_to :script
belongs_to :pipeline
belongs_to :status

end
