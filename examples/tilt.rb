$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))

require 'freenect4r'

[-25,-15,0,15,25,0].each do |angle| 
  puts "Angle #{angle}"
  Freenect4r.set_tilt(angle)
  sleep(10)
end

Freenect4r.stop
