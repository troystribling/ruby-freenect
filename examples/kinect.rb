$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
require 'freenect'

video_mode_count = Freenect.get_video_mode_count
puts "Video Mode Count: #{video_mode_count}"
video_mode_count.times do |mode_id|
end 

depth_mode_count = Freenect.get_depth_mode_count
puts "Depth Mode Count: #{depth_mode_count}"
depth_mode_count.times do |mode_id|
end 
