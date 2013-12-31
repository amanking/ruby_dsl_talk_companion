require 'rspec'

Dir["**/*.rb"].each { |file| require File.expand_path(file, ".") unless file.start_with?("spec/") }