module Freenect4r
  
  class << self
    def method_missing(meth, *args, &blk)
      Interface.send(meth, *args, &blk)
    end
  end
  
  class Interface
    extend Freenect4r::Driver

    class << self
            
      def get_video_mode_count
        freenect_get_video_mode_count
      end
      
      def get_video_mode(mode_id)
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

      def set_led(led, idx=0)
        frrenect_sync_set_led(led, idx)
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
