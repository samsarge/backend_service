# All validations related to the structure field of a table
class StructureValidator < ActiveModel::Validator
  # Add more here when we need more for our tables.
  REQUIRED_STRUCTURE_KEYS = %w[columns].freeze

  def validate(object)
    @object = object

    validate_existence_of_required_structure_keys
    validate_columns_is_array
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

    @object.errors.add(:structure, "missing required keys: #{missing_keys.join(', ')}")
  end
end
