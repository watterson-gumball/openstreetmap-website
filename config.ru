# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

map '/app' do
  run Rails.application
end

Rails.application.load_server
