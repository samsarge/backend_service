module Multitenanted
  class Record < ApplicationRecord
    belongs_to :table,
               class_name: 'Multitenanted::Table',
               foreign_key: :multitenanted_table_id,
               inverse_of: :records

    before_validation :underscore_values_field_keys!

    validate :values_match_the_structure_of_the_table

    validates :multitenanted_table_id, presence: true

    def as_hash_for_json
      # Serializers all work on the class level and we need to dynamically interpret the
      # columns and fields on the instance level so for now we just use this
      { table.name.singularize => { id: id }.merge(values) }
    end

    private

    def underscore_values_field_keys!
      # we need to enforce a standard. So we'll do underscore to reduce backend parsing later on
      self.values = values.each_with_object({}) { |(k, v), hash| hash[k.underscore] = v }
    end

    def values_match_the_structure_of_the_table
      structure_columns = table.structure['columns'].map { |col_hash| col_hash['name'] }
      keys_mismatching_structure = values.keys - structure_columns

      return unless keys_mismatching_structure.any?

      errors.add(:values,
                 'These values don\'t match the table structure: '\
                 "#{keys_mismatching_structure.join(', ')}")
    end
  end
end
