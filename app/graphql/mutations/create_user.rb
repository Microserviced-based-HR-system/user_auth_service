class Mutations::CreateUser < Mutations::BaseMutation
  argument :email, String, required: true
  argument :password, String, required: true
  argument :username, String, required: true

  field :user, Types::UserType, null: false
  field :errors, [String], null: false

  def resolve(email:, password:, username:)
    user = User.new(email: email, password: password, username: username)

    if user.save
      { user: user, errors: [] }
    else
      { user: nil, errors: user.errors.full_messages }
    end
  end
end