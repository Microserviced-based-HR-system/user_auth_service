# Use the official Ruby image as the base image
FROM ruby:3.1.3

# Set environment variables for Rails
ENV APP_HOME /app

# Create and set the working directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Install essential dependencies
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

# Install bundler
RUN gem install bundler

# Copy the Gemfile and Gemfile.lock into the image and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5

# Copy over our application code
ADD . $APP_HOME

# Set our environment variables
ENV RAILS_ENV staging 
ENV RAILS_LOG_TO_STDOUT true 
#ensures our rails logs will be exposed from the container (useful for debugging!)

# Configure endpoint.
COPY /entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3001
