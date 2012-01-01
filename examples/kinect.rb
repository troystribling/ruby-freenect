$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib")) << File.expand_path(File.dirname(__FILE__))
require 'freenect'
require 'tools'

video_mode_count = Freenect.get_video_mode_count
puts "Video Mode Count: #{video_mode_count}"
puts "Supported Video Modes"
video_mode_count.times do |mode_id|
  frame_mode = Freenect.freenect_get_video_mode(mode_id)
  puts "Mode ID: #{mode_id}"
  print_video_mode(frame_mode)
end 

depth_mode_count = Freenect.get_depth_mode_count
puts "Depth Mode Count: #{depth_mode_count}"
puts "Supported Depth Modes"
depth_mode_count.times do |mode_id|
  frame_mode = Freenect.freenect_get_depth_mode(mode_id)
  puts "Mode ID: #{mode_id}"
  print_depth_mode(frame_mode)
end 

puts "Find Video Mode with Resoultion ':freenect_resolution_medium' and Format ':freenect_video_rgb'"
frame_mode = Freenect.find_video_mode(:freenect_video_rgb, :freenect_resolution_medium)
print_video_mode(frame_mode)

puts "Find Depth Mode with Resoultion ':freenect_resolution_medium' and Format ':freenect_depth_11bit'"
frame_mode = Freenect.find_depth_mode(:freenect_depth_11bit, :freenect_resolution_medium)
print_depth_mode(frame_mode)
