# All validations related to the structure field of a table
class StructureValidator < ActiveModel::Validator
  # Add more here when we need more for our tables.
  REQUIRED_STRUCTURE_KEYS = %w[columns].freeze

  def validate(object)
    @object = object

    validate_existence_of_required_structure_keys
    validate_columns_is_array
    validate_existance_of_column_keys
    validate_correct_datatypes
  end

  private

  def validate_columns_is_array
    return unless @object.structure # handled by key existence check

    return if @object.structure['columns'].is_a? Array

    @object.errors.add(:structure, '\'colums\' must be an array')
  end

  def validate_existence_of_required_structure_keys
    missing_keys = REQUIRED_STRUCTURE_KEYS - (@object.structure&.keys || [])
    return unless missing_keys.any?

    @object.errors.add(:structure, "missing required top level keys: #{missing_keys.join(', ')}")
  end

  def validate_existance_of_column_keys
    column_keys = ['name', 'datatype']
    missing_keys = []
    @object.structure['columns'].each do |col_hash|
      column_keys.each do |required_key|
        missing_keys << required_key if col_hash[required_key].nil?
      end
    end

    return if missing_keys.empty?

    @object.errors.add(:structure, "a column is missing keys: #{missing_keys.join(', ')}")
  end

  def validate_correct_datatypes
    datatypes = Multitenanted::Table::DATATYPES

    @object.structure['columns'].each do |col_hash|
      next if col_hash['datatype'].in? datatypes
      @object.errors.add(:structure, "#{col_hash['datatype']} is an invalid datatype")
    end
  end
end
