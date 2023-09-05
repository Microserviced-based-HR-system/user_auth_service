class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :username

  has_many :roles, serializer: RoleSerializer

  attributes :roles do |obj|
    obj.roles.pluck(:name)
  end
end