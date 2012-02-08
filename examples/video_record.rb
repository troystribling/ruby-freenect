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

frame = 0
time_start = Time.now

while recording do
  frame += 1
  frame_buffer = Freenect.get_video(video_mode)
  file.write frame_buffer
end

time_running = Time.now - time_start
puts "TOTAL FRAMES: #{frame}"
puts "TOTAL TIME:   #{time_running}"
puts "FRAME RATE:   #{frame/time_running}"

at_exit do
  file.close
  Freenect.stop
end

