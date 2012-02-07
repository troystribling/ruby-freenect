$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib")) << File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require 'freenect'
require 'tools'

puts "#{Freenect.get_device_count} Kinect found"
depth_mode = Freenect.find_depth_mode(:freenect_depth_11bit)
print_depth_mode(depth_mode)
file = File.open(ARGV.first, 'wb')
recording = true
puts "STARTING RECORDING TO FILE: #{ARGV.first}"

trap('INT') do
  puts "STOPPING"
  recording = false
end

frame = 0
time_start = Time.now

while recording do
  frame += 1
  file.puts Freenect.get_depth(depth_mode)
  puts "FRAME: #{frame}" if frame % 30 == 0
end

time_running = Time.now - time_start
puts "TOTAL FRAMES: #{frame}"
puts "TOTAL TIME:   #{time_running}"
puts "FRAME RATE:   #{frame/time_running}"

at_exit do
  Freenect.stop
end


