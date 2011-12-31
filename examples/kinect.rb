$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib")) << File.expand_path(File.dirname(__FILE__))
require 'freenect'
require 'tools'

context = Freenect.init
device = context.get_device

puts "Number of Devices: #{context.get_device_count}"

video_mode_count = Freenect.get_video_mode_count
puts "Video Mode Count: #{video_mode_count}"
puts "Supported Video Modes"
video_mode_count.times do |mode_id|
  frame_mode = Freenect.freenect_get_video_mode(mode_id)
  puts "Mode ID: #{mode_id}"
  print_video_mode(frame_mode)
end 

puts "Current Depth Mode"
frame_mode = device.get_current_depth_mode
print_frame_mode(frame_mode)

depth_mode_count = Freenect.get_depth_mode_count
puts "Depth Mode Count: #{depth_mode_count}"
puts "Supported Depth Modes"
depth_mode_count.times do |mode_id|
  frame_mode = Freenect.freenect_get_depth_mode(mode_id)
  puts "Mode ID: #{mode_id}"
  print_depth_mode(frame_mode)
end 

puts "Find Video Mode with Resoultion ':freenect_resolution_medium' and Format ':freenect_video_rgb'"
frame_mode = Freenect.find_video_mode(:freenect_resolution_medium, :freenect_video_rgb)
print_video_mode(frame_mode)

puts "SET Video Mode with Resoultion ':freenect_resolution_medium' and Format ':freenect_video_rgb'"
device.set_video_mode(frame_mode)

puts "Current Video Mode"
frame_mode = device.get_current_video_mode
print_video_mode(frame_mode)

puts "Find Depth Mode with Resoultion ':freenect_resolution_medium' and Format ':freenect_depth_11bit'"
frame_mode = Freenect.find_depth_mode(:freenect_resolution_medium, :freenect_depth_11bit)
print_depth_mode(frame_mode)

puts "SET Depth Mode with Resoultion ':freenect_resolution_medium' and Format ':freenect_depth_11bit'"
device.set_depth_mode(frame_mode)

puts "Current Depth Mode"
frame_mode = device.get_current_depth_mode
print_depth_mode(frame_mode)
