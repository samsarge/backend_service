# Would rather have called this settings
# but rails would singularize it as setting so configration it is
class Configuration < ApplicationRecord
  belongs_to :backend
end
