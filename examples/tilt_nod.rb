$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))

require 'freenect4r'

[-30,-15,0,15,30].each do |angle| 
  puts "Angle #{angle}"
  Freenect::Sync.set_tilt(angle)
  sleep(10)
end

