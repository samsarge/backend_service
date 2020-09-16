module Multitenanted
  class UserSerializer
    include FastJsonapi::ObjectSerializer
    set_type :user

    attributes :email, :created_at, :updated_at
  end
end
