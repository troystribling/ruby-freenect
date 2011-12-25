$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
require 'freenect4r'

puts "LED GREEN"
Freenect4r.set_led(Freenect4r::FREENECT_LED_OPTIONS[:led_green])
sleep(5)
puts "LED RED"
Freenect4r.set_led(Freenect4r::FREENECT_LED_OPTIONS[:led_red])
sleep(5)
puts "LED YELLOW"
Freenect4r.set_led(Freenect4r::FREENECT_LED_OPTIONS[:led_yellow])
sleep(5)
puts "LED BLINK GREEN"
Freenect4r.set_led(Freenect4r::FREENECT_LED_OPTIONS[:led_blink_green])
sleep(5)
puts "LED BLINK RED/YELLOW"
Freenect4r.set_led(Freenect4r::FREENECT_LED_OPTIONS[:led_blink_red_yellow])
sleep(5)
puts "LED OFF"
Freenect4r.set_led(Freenect4r::FREENECT_LED_OPTIONS[:led_off])
Freenect4r.stop
