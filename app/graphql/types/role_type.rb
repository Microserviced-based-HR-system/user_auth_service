# frozen_string_literal: true

module Types
  class RoleType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :resource_type, String
    field :resource_id, Types::UuidType
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
