module Permissionable
  extend ActiveSupport::Concern

  included do
    validates :permission_bitmask,
              numericality: {
                only_integer: true,
                greater_than_or_equal_to: 0,
                less_than_or_equal_to: 15
              }
  end

  BITMASK = {
    create: 0b1000,
    read:   0b0100,
    update: 0b0010,
    delete: 0b0001
  }.freeze

  def can?(action)
    permission_bitmask & BITMASK[action] > 0
  end
end
