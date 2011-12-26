module Freenect
  class DeviceError < StandardError;end

  class Device
    include Freenect::Driver
    
    attr_reader :contect, :device, :closed, :depth_format, :video_format
    
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
      freenect_get_current_video_mode(device)
    end

    def set_video_mode(frame_mode)
      freenect_set_video_mode(device, frame_mode)
    end
    
    def get_current_depth_mode
      freenect_get_current_depth_mode(device)
    end

    def set_depth_mode(frame_mode)
      freenect_set_depth_mode(device, frame_mode)
    end
    
    def set_led(led_option)
      freenect_set_led(device, Freenect::FREENECT_LED_OPTIONS[led_option]) == 0
    end

    def video_buffer
      if @video_buffer and @video_buf_size
        @video_buffer.read_string_length(@video_buf_size)
      end
    end

    def depth_buffer
      if @depth_buffer and @depth_buffer_size
        @depth_buffer.read_string_length(@depth_buffer_size)
      end
    end

    private

      def init_depth_buffer(fmt)
        if (sz = lookup_depth_size(fmt)).nil?
          raise(ArgumentError, "invalid depth format: #{fmt.inspect}")
        end
        @depth_buffer_size = sz
        @depth_buffer = MemoryPointer.new(@depth_buf_size)
        freenect_set_depth_buffer(device, @depth_buffer)
      end

      def init_video_buffer(fmt)
        if (sz = Freenect.lookup_video_size(fmt)).nil?
          raise(FormatError, "invalid video format: #{fmt.inspect}")
        end
        @video_buffer_size = sz
        @video_buffer = MemoryPointer.new(@video_buf_size)
        freenect_set_video_buffer(device, @video_buffer)
      end

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
