def print_video_mode(frame_mode)
  puts "  Format:                 #{frame_mode[:format][:video_format]}"
  print_frame_mode(frame_mode)
end

def print_depth_mode(frame_mode)
  puts "  Format:                 #{frame_mode[:format][:depth_format]}"
  print_frame_mode(frame_mode)
end

def print_frame_mode(frame_mode)
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

def sync_keyboard
  tilt = 0
  lambda do |key, x, y|
  	case (key.chr)
    when ('0'..'5')
      Freenect.set_led Freenect::FREENECT_LED_OPTIONS.symbols[key.chr.to_i]
    when 'u'
      Freenect.set_tilt (tilt = [25, tilt + 5].min)
    when 'd'
      Freenect.set_tilt (tilt = [-25, tilt - 5].max)
    when 'c'
      Freenect.set_tilt (tilt = 0)
    when 'm'
      depth_mode = Freenect.get_current_depth_mode
      if depth_mode
        puts "Current Depth Mode"
        print_depth_mode(depth_mode)
      end
      video_mode = Freenect.get_current_video_mode
      if video_mode
        puts "Current Video Mode"
        print_video_mode(video_mode)
      end
    when 'q'
      Freenect.set_led :led_off
      Freenect.set_tilt 0
      Freenect.stop
      puts "Closing Kinect"
      exit(0)
    end
  end
end
