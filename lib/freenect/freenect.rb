module Freenect
  
  FREENECT_COUNTS_PER_G     = Driver::FREENECT_COUNTS_PER_G
  FREENECT_DEVICE_FLAGS     = Driver::FREENECT_DEVICE_FLAGS
  FREENECT_RESOLUTION       = Driver::FREENECT_RESOLUTION
  FREENECT_VIDEO_FORMAT     = Driver::FREENECT_VIDEO_FORMAT
  FREENECT_DEPTH_FORMAT     = Driver::FREENECT_DEPTH_FORMAT
  FREENECT_LED_OPTIONS      = Driver::FREENECT_LED_OPTIONS
  FREENECT_TILT_STATUS_CODE = Driver::FREENECT_TILT_STATUS_CODE
  FREENECT_LOGLEVEL         = Driver::FREENECT_LOGLEVEL
  
  class << self
    def method_missing(meth, *args, &blk)
      Interface.send(meth, *args, &blk)
    end
    def init(*args)
      Context.new(*args)
    end
  end
  
  class Interface
    extend Freenect::Driver

    class << self
            
      def get_video_mode_count
        freenect_get_video_mode_count
      end
      
      def get_video_mode(mode_id)
        freenect_get_video_mode(mode_id)
      end
      
      def find_video_mode(resolution, format)
        freenect_find_video_mode(resolution, format)
      end

      def get_video(idx=0, fmt=:freenect_video_rgb)
        video_p = pointer(:pointer)
        timestamp_p = pointer(:uint32)
        ret = freenect_sync_get_video(video_p, timestamp_p, idx, Freenect.lookup_video_format(fmt))
        if ret != 0
          raise("Unknown error in freenect_sync_get_video()")
        else
          [timestamp_p.read_int, video_p.read_string_length(buf_size)]
        end
      end

      def get_depth_mode_count
        freenect_get_depth_mode_count
      end

      def get_depth_mode(mode_id)
        freenect_get_depth_mode(mode_id)
      end

      def find_depth_mode(resolution, format)
        freenect_find_depth_mode(resolution, format)
      end
        
      def get_depth(idx=0, fmt=:freenect_depth_11bit)
        depth_p = pointer(:pointer)
        timestamp_p = pointer(:uint32)
        ret = freenect_sync_get_depth(depth_p, timestamp_p, idx, Freenect.lookup_depth_format(fmt))
        if ret != 0
          raise("Unknown error in freenect_sync_get_depth()") # TODO is errno set or something here?
        else
          return [timestamp_p.read_int, video_p.read_string_length(buf_size)]
        end
      end

      def set_tilt(angle, idx=0)
        freenect_sync_set_tilt_degs(angle, idx)
      end

      def get_tilt(tilt_state=nil, idx=0)
        tilt_state ||= get_tilt_state(idx)
        freenect_get_tilt_degs(tilt_state)
      end
      
      def get_tilt_status(tilt_state=nil, idx=0)
        tilt_state ||= get_tilt_state(idx)
        freenect_get_tilt_status(tilt_state)
      end
      
      def get_tilt_state(idx=0)
        state_ptr = pointer(:pointer)
        freenect_sync_get_tilt_state(state_ptr, idx)
        FreenectRawTiltState.new(state_ptr.get_pointer(0))
      end

      def get_acceleration(tilt_state=nil, idx=0)
        tilt_state ||= get_tilt_state(idx)
        xacc = pointer(:double)
        yacc = pointer(:double)
        zacc = pointer(:double)
        freenect_get_mks_accel(tilt_state, xacc, yacc, zacc)
        {:x=>xacc.read_double, :y=>yacc.read_double, :z=>zacc.read_double}
      end

      def set_led(led_option, idx=0)
        freenect_sync_set_led(Freenect::FREENECT_LED_OPTIONS[:led_option], idx)
      end
      
      def stop
        freenect_sync_stop()
      end

      private
      
        def pointer(type)
          FFI::MemoryPointer.new(type)
        end
      
    end
  end
end
