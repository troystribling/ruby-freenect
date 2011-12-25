$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
require 'freenect'

[-25,-15,0,15,25,0].each do |angle| 
  puts "Set Tilt Angle: #{angle}"
  tilt_state = Freenect.get_tilt_state
  tilt_angle = Freenect.get_tilt(tilt_state)
  tilt_status = Freenect.get_tilt_status(tilt_state)
  acc = Freenect.get_acceleration(tilt_state)
  puts "Current Tilt Angle: #{tilt_angle}"
  puts "Tilt Status: #{tilt_status}"
  puts "Acceleration: #{acc.inspect}"
  Freenect.set_tilt(angle)
  sleep(10)
end

Freenect.stop
