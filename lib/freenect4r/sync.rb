module Freenect
  class Sync
    extend Driver

    class << self
      
      def get_video(idx=0, fmt=:freenect_video_rgb)
        video_p = MemoryPointer.new(:pointer)
        timestamp_p = MemoryPointer.new(:uint32)
        ret = freenect_sync_get_video(video_p, timestamp_p, idx, Freenect.lookup_video_format(fmt))
        if ret != 0
          raise("Unknown error in freenect_sync_get_video()")
        else
          {:timestamp => timestamp_p.read_int, video_p.read_string_length(buf_size)]
        end
      end

      def get_depth(idx=0, fmt=:freenect_depth_11bit)
        depth_p = MemoryPointer.new(:pointer)
        timestamp_p = MemoryPointer.new(:uint32)
        ret = freenect_sync_get_depth(depth_p, timestamp_p, idx, Freenect.lookup_depth_format(fmt))
        if ret != 0
          raise("Unknown error in freenect_sync_get_depth()") # TODO is errno set or something here?
        else
          return [timestamp_p.read_int, video_p.read_string_length(buf_size)]
        end
      end

      def set_tilt(angle, idx=0)
        freenect_syn_set_tilt_degs(angle, idx)
      end

      def get_tilt(idx=0)
        state_ptr = MemoryPointer.new(:pointer)
        freenect_get_tilt_state(state_ptr, idx)
        state_ptr = state_ptr.read_pointer()
        state_ptr.read_int()
      end

      def set_led(led, idx=0)
        frrenect_sync_set_led(led, idx)
      end
      
      def stop
        freenect_sync_stop()
      end

    end
  end
end
