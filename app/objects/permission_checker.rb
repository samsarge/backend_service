# As well as settings to enable / disable features
# tables have individual controls for each action that can be performed on them via
# the API as well. This class will wrap all the bullshit so it's in one place and just
# explicitly coded.

# Before I had approached permissions with clever method missing bitmap methods but now the best
# thing to do is just have the checks explicitly written out so it's very clear how they operate

# Backends have settings to enable / disable:
# Setting: User registrations
# Setting: User sessions
# Setting: Tables
# Bitmask Permission: Tables have CRUD permissions that enable/disable access to the endpoints individually
class PermissionChecker
  def initialize(backend)
    @backend = backend
    @configuration = @backend.configuration
  end

  def user_registration_actions
    raise NoPermissionError unless @configuration.user_registrations_enabled?
  end

  def user_session_actions
    raise NoPermissionError unless @configuration.user_sessions_enabled?
  end

  def table_record_actions(table:, action:)
    permission_to_check = CONTROLLER_ACTION_TO_PERMISSION[action.to_sym]

    unless @configuration.custom_data_enabled? &&
      (table.permission_bitmask & TABLE_PERMISSION_BITMASK[permission_to_check] > 0)

      raise NoPermissionError
    end
  end

  private

  CONTROLLER_ACTION_TO_PERMISSION = {
    index: :read,
    show: :read,
    create: :create,
    update: :update,
    destroy: :delete
  }.freeze

  TABLE_PERMISSION_BITMASK = {
    create: 0b1000,
    read:   0b0100,
    update: 0b0010,
    delete: 0b0001
  }.freeze
end
