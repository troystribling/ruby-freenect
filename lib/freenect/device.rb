module Freenect
  class DeviceError < StandardError;end

  class Device
    include Freenect::Driver
    
    attr_reader :context, :device, :closed, :depth_mode, :video_mode
    
    def initialize(context, idx=0)
      dev_p = FFI::MemoryPointer.new(:pointer)
      @context = context
      if freenect_open_device(@context.context, dev_p, idx) != 0
        raise DeviceError, "unable to open device #{idx} from #{ctx.inspect}"
      end
      @device, @closed = dev_p.read_pointer, false
      set_user
    end

    def closed?
      context.closed? or @closed
    end

    def close
      unless closed?
        if freenect_close_device(device) == 0
          @closed = true
        end
      end
    end

    def device
      @closed ? raise(DeviceError, "this device is closed and can no longer be used") : @device
    end

    def set_depth_callback(&block)
      @depth_callback = block
      freenect_set_depth_callback(device, @depth_callback)
    end

    def set_video_callback(&block)
      @video_callback = block
      freenect_set_video_callback(device, @video_callback)
    end

    def start_depth
      unless(freenect_start_depth(device) == 0)
        raise DeviceError, "Error in freenect_start_depth()"
      end
    end

    def stop_depth
      unless(freenect_stop_depth(device) == 0)
        raise DeviceError, "Error in freenect_stop_depth()"
      end
    end

    def start_video
      unless(freenect_start_video(device) == 0)
        raise DeviceError, "Error in freenect_start_video()"
      end
    end

    def stop_video
      unless(freenect_stop_video(device) == 0)
        raise DeviceError, "Error in freenect_stop_video()"
      end
    end

    def get_current_video_mode
      @video_mode = freenect_get_current_video_mode(device)
    end

    def set_video_mode(frame_mode)
      @video_mode = frame_mode
      set_video_buffer
      freenect_set_video_mode(device, frame_mode)
    end
    
    def get_current_depth_mode
      @depth_mode = freenect_get_current_depth_mode(device)
    end

    def set_depth_mode(frame_mode)
      @depth_mode = frame_mode
      set_depth_buffer
      freenect_set_depth_mode(device, frame_mode)
    end
    
    def set_led(led_option)
      freenect_set_led(device, Freenect::FREENECT_LED_OPTIONS[led_option])
    end

    def set_tilt(tilt_deg)
      freenect_set_tilt_degs(device, tilt_deg)
    end
    
    def video_buffer
      video_mode_valid? ? @video_buffer.read_string_length(video_mode[:bytes]) : []
    end

    def depth_buffer
      depth_mode_valid? ?  @depth_buffer.read_string_length(depth_mode[:bytes]) : []
    end

    def video_mode_valid?
      video_mode and (video_mode[:is_valid] == 1)
    end

    def depth_mode_valid?
      depth_mode and (depth_mode[:is_valid] == 1)
    end

    def set_depth_buffer
      if depth_mode_valid?
        @depth_buffer = FFI::MemoryPointer.new(depth_mode[:bytes])
        freenect_set_depth_buffer(device, @depth_buffer)
      else
        raise DeviceError, "depth_mode is invalid"
      end
    end

    def set_video_buffer
      if video_mode_valid?
        @video_buffer = FFI::MemoryPointer.new(video_mode[:bytes])
        freenect_set_video_buffer(device, @video_buffer)
      else
        raise DeviceError, "video_mode is invalid"
      end
    end
    
    private

      def get_user
        unless (p=freenect_get_user(device)).null?
          p.read_long_long
        end
      end

      def set_user
        @objid_p = FFI::MemoryPointer.new(:long_long)
        @objid_p.write_long_long(object_id)
        freenect_set_user(device, @objid_p)
      end

      def update_tilt_state
        freenect_update_tilt_state(device)
      end

  end
end
