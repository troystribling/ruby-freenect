module Freenect
  class ContextError < StandardError; end

  class Context  
      
    include Driver

    def initialize(usb_ctx=nil)
      ctx_p = MemoryPointer.new(:pointer)
      if freenect_init(ctx_p, usb_ctx) != 0
        raise ContextError, "freenect_init() returned nonzero"
      elsif ctx_p.null?
        raise ContextError, "freenect_init() produced a NULL context"
      end
      @ctx = ctx_p.read_pointer
    end

    def context
      if @ctx_closed
        raise ContextError, "This context has been shut down and can no longer be used"
      else
        @ctx
      end
    end

    def num_devices
      freenect_num_devices(self.context)
    end

    def device(idx)
      return Device.new(self, idx)
    end
    alias [] device

    def set_log_level(loglevel)
      freenect_set_log_level(self.context, loglevel)
    end
    alias log_level= set_log_level

    def set_log_callback(&block)
      freenect_set_log_callback(self.context, block)
    end

    def process_events
      freenect_process_events(self.context)
    end

    def close
      unless closed?
        raise(ContextError, "freenect_shutdown() returned nonzero") if freenect_shutdown(@ctx) != 0
        @ctx_closed = true
      end
    end
    
    def closed?
      @ctx_closed
    end
  end
end
