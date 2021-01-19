require 'rubygems'
require 'bundler/setup'
require 'dotenv/load'
require 'sinatra'
require 'ldclient-rb'

LD_CLIENT = LaunchDarkly::LDClient.new(ENV['LD_API_KEY'])

def new_products
  if experiment_with_user?("new-products-flag", "user@test.com")  
    "Here are some new products on sale." 
  else
    "Check back later for new products."
  end
end

def experiment_with_user?(flag, key)
  LD_CLIENT.variation(flag, {key: key}, false)
end

get '/products' do
  "We have great an impressive catalog of existing products. #{new_products}"
end

at_exit { LD_CLIENT.close }
