# Cookbook:: apache
# Recipe:: server
#
# Copyright:: 2017, The Authors, All Rights Reserved.

puts "THIS IS THE START OF THE APACHE::SERVER RECIPE ***************"
package 'httpd' do
  action :install
end

#file '/var/www/html/index.html' do
#  content '<h1>Hello World! Today is a brand new day!!</h1>'
#end

# Now use string interpolation.  Have to change single quotes to double.
# Also demo two ways to include the node object information.

hostname = node['hostname']

#file '/var/www/html/index.html' do
#  content "<h1>Hello World! Using file resource and string interpolation!!</h1>
#  HOSTNAME: #{hostname}
#  IP ADDRESS: #{node['ipaddress']}
#  CPU: #{node['cpu']['0']['mhz']}
#  MEMORY: #{node['memory']['total']} 
#"
#end


remote_file '/var/www/html/cubs_logo.jpg' do
  source 'https://www.mlbstatic.com/mlb.com/images/share/112.jpg'
end



#Use a guard not_if to do this resource.  Other guard is only_if.
#bash resource is not best since some OSes don't have bash.
bash 'inline script' do
  user 'root'
  code 'mkdir -p /var/www/my_assets1/ && chown -R apache /var/www/my_assets1/'
  not_if '[ -d /var/www/my_assets1/ ]'
end



#This method is more generic than bash resource
#Could specify the command to execute a file like this instead of inline ...
#  command '/etc/myscript.sh'
execute 'create my_assets2 dir' do
  user 'root'
  command <<-EOH
  mkdir -p /var/www/my_assets2/ /
  chown -R apache /var/www/my_assets2/
  EOH
  not_if do
    File.directory?('/var/www/my_assets2/')
  end
end


#This method is the best for creating a directory. recursive means that it will create the parent directories also.
#Since this is a chef resource, it automatically tests for idempotency.  No guard is needed.
directory '/var/www/my_assets3' do
   owner 'apache'
  recursive true
  mode '0755'
end


template '/var/www/html/index.html' do
  source 'index.html.erb'
end

service 'httpd' do
  action [ :enable, :start ]
end

