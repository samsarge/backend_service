# Namespace that defines what models are multitenanted as opposed to relational.
module Multitenanted
  def self.table_name_prefix
    'multitenanted_'
  end
end
