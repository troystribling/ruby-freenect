$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib")) << File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require 'freenect'

puts "#{Freenect.get_device_count} Kinect found"
video_mode = Freenect.find_video_mode(:freenect_video_rgb)
file = File.open(ARGV.first, 'wb')
recording = true
puts "STARTING RECORDING TO FILE: #{ARGV.first}"

trap('INT') do
  puts "STOPPING"
  recording = false
end

while recording do
 file.puts Freenect.get_video(video_mode)
end

at_exit do
  Freenect.stop
end

