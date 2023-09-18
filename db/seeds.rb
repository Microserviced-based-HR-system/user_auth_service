# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Create an "Administrator" user account.
admin = User.create(
    email: 'hrisadmin@example.com',
    password: 'abcABC1', # Set a secure password here.
    password_confirmation: 'abcABC1', # Make sure it matches the password above.
    username: 'admin'
  )

admin.add_role('administrator')
admin.save!
puts "Administrator user created with email: #{admin.email}"

# Create an "Administrator" user account.
hr_manager = User.create(
    email: 'hr@example.com',
    password: 'abcABC1', # Set a secure password here.
    password_confirmation: 'abcABC1', # Make sure it matches the password above.
    username: 'hr_manager'
  )
hr_manager.add_role('hr_manager')
hr_manager.save!
puts "Hr manager user created with email: #{hr_manager.email}"