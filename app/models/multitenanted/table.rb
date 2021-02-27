module Multitenanted
  # Multitenanted table object that people use to store data in their backends
  class Table < ApplicationRecord
    has_many :records,
             class_name: 'Multitenanted::Record',
             inverse_of: :table,
             foreign_key: :multitenanted_table_id,
             dependent: :destroy

    validates_with StructureValidator

    validates :name, uniqueness: { presence: true }

    validates :permission_bitmask,
          numericality: {
            only_integer: true,
            greater_than_or_equal_to: 0,
            less_than_or_equal_to: 15
          }

    before_save :configure_table_name!
    before_save :underscore_column_names!

    def json_example
      {
        name.singularize => structure['columns'].each_with_object({}) do |col, hash|
          hash[col] = 'example'
        end
      }.to_json
    end

    private

    def underscore_column_names!
      # see record model, we enforce underscoring
      return unless structure['columns']

      structure['columns'].map!(&:underscore)
    end

    def configure_table_name! # Underscore and pluralize the table name
      self.name = name.squish.downcase.tr(' ', '_').pluralize
    end
  end
end
