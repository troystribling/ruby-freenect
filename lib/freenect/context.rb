module Freenect
  class ContextError < StandardError; end

  class Context        
    include Freenect::Driver

    def initialize(usb_ctx=nil)
      ctx_p = FFI::MemoryPointer.new(:pointer)
      if freenect_init(ctx_p, usb_ctx) != 0
        raise ContextError, "freenect_init() returned nonzero"
      elsif ctx_p.null?
        raise ContextError, "freenect_init() produced a NULL context"
      end
      @context, @closed, @devices = ctx_p.read_pointer, false, {}
    end

    def context
      @closed ? raise(ContextError, "This context has been shut down and can no longer be used") :  @context
    end

    def get_device_count
      freenect_num_devices(context)
    end

    def devices
      @devices.values
    end
    
    def get_device(idx=0)
      @devices[idx] ||= Device.new(self, idx=0)
    end

    def set_log_level(log_level)
      freenect_set_log_level(context, log_level)
    end

    def set_log_callback(&block)
      freenect_set_log_callback(context, block)
    end

    def process_events
      freenect_process_events(context)
    end

    def close
      unless closed?
        devices.each{|d| d.close}
        raise(ContextError, "freenect_shutdown() returned nonzero") if freenect_shutdown(@context) != 0
        @closed = true
      end
    end
    
    def closed?
      @closed
    end
  end
end
