$:.unshift(File.dirname(__FILE__))
require 'ffi'
require 'freenect4r/driver'
require 'freenect4r/sync'

# module Freenect4r

#   def self.init(*args)
#     Context.new(*args)
#   end
# 
#   def self.lookup_video_format(fmt)
#     return (fmt.is_a?(Numeric) ? fmt : FFI::Freenect::VIDEO_FORMATS[fmt])
#   end
# 
#   def self.lookup_video_size(fmt)
#     l_fmt = (fmt.is_a?(Numeric) ? FFI::Freenect::VIDEO_FORMATS[fmt] : fmt)
#     if l_fmt.nil? or (sz = FFI::Freenect::VIDEO_SIZES[l_fmt]).nil?
#       return nil
#     else
#       return sz
#     end
#   end
# 
#   def self.lookup_depth_format(fmt)
#     return (fmt.is_a?(Numeric) ? fmt : FFI::Freenect::DEPTH_FORMATS[fmt])
#   end
# 
#   def self.lookup_depth_size(fmt)
#     l_fmt = (fmt.is_a?(Numeric) ? FFI::Freenect::DEPTH_FORMATS[fmt] : fmt)
#     if l_fmt.nil? or (sz = FFI::Freenect::DEPTH_SIZES[l_fmt]).nil?
#       return nil
#     else
#       return sz
#     end
#   end
# end
