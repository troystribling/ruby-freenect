def print_video_mode(frame_mode)
  puts "  Format:                 #{frame_mode[:format][:video_format]}"
  puts "  Resolution:             #{frame_mode[:resolution]}"
  puts "  Bytes:                  #{frame_mode[:bytes]}"
  puts "  Width:                  #{frame_mode[:width]}"
  puts "  Height:                 #{frame_mode[:height]}"
  puts "  Data Bits Per Pixel:    #{frame_mode[:data_bits_per_pixel]}"
  puts "  Padding Bits Per Pixel: #{frame_mode[:padding_bits_per_pixel]}"
  puts "  Framerate:              #{frame_mode[:framerate]}"
  puts "  Is Valid:               #{frame_mode[:is_valid]}"
end

def print_current_video_mode(device)
  puts "Current Video Mode"
  frame_mode = device.get_current_video_mode
  print_video_mode(frame_mode)
end

def check_for_kinect(context)
  kinect_count = context.get_device_count
  if kinect_count == 0
    puts "No Kinect Found"
    exit(1)
  else
    puts "Number of Kinects: #{kinect_count}"
  end
end

def keyboard(device, context)
  tilt = 0
  lambda do |key, x, y|
  	case (key.chr)
    when ('0'..'5')
      device.set_led Freenect::FREENECT_LED_OPTIONS.symbols[key.chr.to_i]
    when 'u'
      device.set_tilt (tilt = [25, tilt + 5].min)
    when 'd'
      device.set_tilt (tilt = [-25, tilt - 5].max)
    when 'c'
      device.set_tilt (tilt = 0)
    when 'e'
      device.set_led :led_off
      device.set_tilt (tilt = 0)
      device.stop_video
      device.stop_depth
      context.close
      puts "Closing Kinect"
      exit(0)
    end
  end
end
