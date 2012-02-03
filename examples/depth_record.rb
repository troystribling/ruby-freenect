$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib")) << File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require 'freenect'

puts "#{Freenect.get_device_count} Kinect found"
depth_mode = Freenect.find_depth_mode(:freenect_depth_11bit)
file = File.open(ARGV.first, 'wb')
recording = true
puts "STARTING RECORDING TO FILE: #{ARGV.first}"

trap('INT') do
  puts "STOPPING"
  recording = false
end

while recording do
 file.puts Freenect.get_depth(depth_mode)
end

at_exit do
  Freenect.stop
end


