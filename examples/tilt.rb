$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
require 'freenect4r'

[-25,-15,0,15,25,0].each do |angle| 
  puts "Set Tilt Angle: #{angle}"
  tilt_state = Freenect4r.get_tilt_state
  tilt_angle = Freenect4r.get_tilt(tilt_state)
  acc = Freenect4r.get_acceleration(tilt_state)
  puts "Current Tilt Angle: #{tilt_angle}"
  puts "Tilt Status: #{tilt_state[:tilt_status]}"
  puts "Acceleration: #{acc.inspect}"
  Freenect4r.set_tilt(angle)
  sleep(10)
end

Freenect4r.stop
