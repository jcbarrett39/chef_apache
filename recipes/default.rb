#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

puts "**** THIS IS THE APACHE::DEFAULT RECIPE *********"
puts "The default recipe contains an include_recipe statement"

include_recipe 'apache::server'
