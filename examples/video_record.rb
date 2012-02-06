$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib")) << File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require 'freenect'
require 'tools'

puts "#{Freenect.get_device_count} Kinect found"
recording = true
puts "STARTING RECORDING TO FILE: #{ARGV.first}"
video_format = (fmt = ARGV[1]).nil? ? :freenect_video_rgb : fmt.to_sym
video_mode = Freenect.find_video_mode(video_format)
print_video_mode(video_mode)
file = File.open(ARGV.first, 'wb')

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

