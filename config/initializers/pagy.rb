# config/initializers/pagy.rb
require 'pagy/extras/headers'
require 'pagy/extras/metadata'
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :empty_page
Pagy::DEFAULT[:items] = 10        # items per page