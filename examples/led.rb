$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
require 'freenect'

puts "LED GREEN"
Freenect.set_led(:led_green)
sleep(5)
puts "LED RED"
Freenect.set_led(:led_red)
sleep(5)
puts "LED YELLOW"
Freenect.set_led(:led_yellow)
sleep(5)
puts "LED BLINK GREEN"
Freenect.set_led(:led_blink_green)
sleep(5)
puts "LED BLINK RED/YELLOW"
Freenect.set_led(:led_blink_red_yellow)
sleep(5)
puts "LED OFF"
Freenect.set_led(:led_off)
Freenect.stop
