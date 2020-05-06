class UserSerializer < ActiveModel::Serializer
  attributes %w[id email admin created_at updated_at]
end
