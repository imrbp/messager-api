class User < ApplicationRecord
  # encrypt password
  has_secure_password
end
