class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :username, :roles

  attributes :roles do |obj|
    obj.roles.pluck(:name)
  end
end
