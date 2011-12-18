require 'rubygems'
require 'ffi'

module Freenect4r

  extend FFI::Library
  ffi_lib 'freenect', 'freenect_sync'
  
  # Ticks per G for accelerometer as set per http://www.kionix.com/Product%20Sheets/KXSD9%20Product%20Brief.pdf
  FREENECT_COUNTS_PER_G = 819

  # Flags representing devices to open when freenect_open_device() is called.
  # In particular, this allows libfreenect to grab only a subset of the devices
  # in the Kinect, so you could (for instance) use libfreenect to handle audio
  # and motor support while letting OpenNI have access to the cameras.
  # If a device is not supported on a particular platform, its flag will be ignored.
  FREENECT_DEVICE_FLAGS = enum(
    :freenect_device_motor,   0x01,
    :freenect_device_camaers, 0x02,
    :freenect_device_audio,   0x04
  )

  # Enumeration of available resolutions.
  # Not all available resolutions are actually supported for all video formats.
  # Frame modes may not perfectly match resolutions.  For instance,
  # FREENECT_RESOLUTION_MEDIUM is 640x488 for the IR camera.
  FREENECT_RESOLUTION = enum(
    :freenect_resolution_low,    0,           # QVGA - 320x240 
    :freenect_resolution_medium, 1,           # VGA  - 640x480 
    :freenect_resolution_high,   2,           # SXGA - 1280x1024
    :freenect_resolution_dummy = 2147483647 , #Dummy value to force enum to be 32 bits wide
  )

  # Enumeration of video frame information states.
  # See http://openkinect.org/wiki/Protocol_Documentation#RGB_Camera for more information.
  FREENECT_VIDEO_FORMAT = enum(
    :freenect_video_rgb,             0,          # Decompressed RGB mode (demosaicing done by libfreenect)
    :freenect_video_bayer,           1,          # Bayer compressed mode (raw information from camera)
    :freenect_video_ir_8bit,         2,          # 8-bit IR mode
    :freenect_video_ir_10bit,        3,          # 10-bit IR mode
    :freenect_video_ir_10bit_packed, 4,          # 10-bit packed IR mode
    :freenect_video_yuv_rgb,         5,          # YUV RGB mode
    :freenect_video_yuv_raw,         6,          # YUV Raw mode
    :freenect_video_dummy,           2147483647  # Dummy value to force enum to be 32 bits wide
  )
  
  # Enumeration of depth frame states
  # See http://openkinect.org/wiki/Protocol_Documentation#RGB_Camera for more information.
  FREENECT_DEPTH_FORMAT = enum(
    :freenect_depth_11bit,        0,         # 11 bit depth information in one uint16_t/pixel
    :freenect_depth_10bit,        1,         # 10 bit depth information in one uint16_t/pixel
    :freenect_depth_11bit_packed, 2,         # 11 bit packed depth information
    :freenect_depth_10bit_packed, 3,         # 10 bit packed depth information
    :freenet_depth_dummy,         2147483647 # Dummy value to force enum to be 32 bits wide 
  )

  # Structure to give information about the width, height, bitrate,
  # framerate, and buffer size of a frame in a particular mode, as
  # well as the total number of bytes needed to hold a single frame.
  class FreenectFormat < FFI::Union
    layout :dummy,        :int16_t,
           :video_format, FREENECT_VIDEO_FORMAT,
           :depth_format, FREENECT_DEPTH_FORMAT
  end 
  class FreenectFrameNode < FFI::Struct
    layout :reserved,               :uint32_t,           # unique ID used internally.  The meaning of values may change without notice.  
                                                         # Don't touch or depend on the contents of this field.  We mean it.
           :resolution,             FREENECT_RESOLUTION, # Resolution this freenect_frame_mode describes, should you want to find it again with freenect_find_*_frame_mode().
           :format,                 FreenectFormat,      # The video or depth format that this freenect_frame_mode describes.  The caller should know which of video_format or 
                                                         # depth_format to use, since they called freenect_get_*_frame_mode()
           :bytes,                  :int32_t,            # Total buffer size in bytes to hold a single frame of data.  Should be equivalent to width * height * 
                                                         # (data_bits_per_pixel+padding_bits_per_pixel) / 8
           :width,                  :int16_t,            # Width of the frame, in pixels
           :height,                 :int16_t,            # Height of the frame, in pixels
           :data_bits_per_pixel,    :int8_t,             # Number of bits of information needed for each pixel
           :padding_bits_per_pixel, :int8_t,             # Number of bits of padding for alignment used for each pixel
           :framerate,              :int8_t,             # Approximate expected frame rate, in Hz
           :is_valid,               :int8_t              # If 0, this freenect_frame_mode is invalid and does not describe a supported mode.  Otherwise, the frame_mode is valid.
  end

  # Enumeration of LED states
  # See http://openkinect.org/wiki/Protocol_Documentation#Setting_LED for more information.
  FREENECT_LED_OPTIONS = enum(
    :led_off,               0, # Turn LED off
    :led_green,             1, # Turn LED to Green
    :led_red,               2, # Turn LED to Red
    :led_yellow,            3, # Turn LED to Yellow
    :led_blink_green,       4, # Make LED blink Green
    :led_blink_red_yellow,  6  # Make LED blink Red/Yellow
  ) 
                              


	DEPTH_11BIT = 0
	DEPTH_10BIT = 1
	DEPTH_11BIT_PACKED = 2
	DEPTH_10BIT_PACKED = 3

  DEPTH_FORMATS = enum( :depth_11bit,         DEPTH_11BIT,
	TILT_STATUS_STOPPED = 0x00
	TILT_STATUS_LIMIT = 0x01
	TILT_STATUS_MOVING = 0x04

  TILT_STATUS_CODES = enum( :stopped,  TILT_STATUS_STOPPED,
                            :limit,    TILT_STATUS_LIMIT,
                            :moving,   TILT_STATUS_MOVING)

 
	LOG_FATAL = 0
	LOG_ERROR = 1
	LOG_WARNING = 2 
	LOG_NOTICE = 3
	LOG_INFO = 4
	LOG_DEBUG = 5
	LOG_SPEW = 6
	LOG_FLOOD = 7

  LOGLEVELS = enum( :fatal,   LOG_FATAL,
                    :error,   LOG_ERROR,
                    :warning, LOG_WARNING,
                    :notice,  LOG_NOTICE,
                    :info,    LOG_INFO,
                    :debug,   LOG_DEBUG,
                    :spew,    LOG_SPEW,
                    :flood,   LOG_FLOOD)
  
  typedef :pointer, :freenect_context
  typedef :pointer, :freenect_device
  typedef :pointer, :freenect_usb_context # actually a libusb_context
 
 
  class RawTiltState < FFI::Struct
    layout :accelerometer_x,  :int16_t,
           :accelerometer_y,  :int16_t,
           :accelerometer_z,  :int16_t, 
           :tilt_angle,       :int8_t, 
           :tilt_status,      TILT_STATUS_CODES
  end

  callback :freenect_log_cb, [:freenect_context, LOGLEVELS, :string], :void
  callback :freenect_depth_cb, [:freenect_device, :pointer, :uint32], :void
  callback :freenect_video_cb, [:freenect_device, :pointer, :uint32], :void

  attach_function :freenect_set_log_level, [:freenect_context, LOGLEVELS], :void
  attach_function :freenect_set_log_callback, [:freenect_context, :freenect_log_cb], :void
  attach_function :freenect_process_events, [:freenect_context], :int
  attach_function :freenect_num_devices, [:freenect_context], :int
  attach_function :freenect_open_device, [:freenect_context, :freenect_device, :int], :int
  attach_function :freenect_close_device, [:freenect_device], :int
  attach_function :freenect_init, [:freenect_context, :freenect_usb_context], :int
  attach_function :freenect_shutdown, [:freenect_context], :int
  attach_function :freenect_set_user, [:freenect_device, :pointer], :void
  attach_function :freenect_get_user, [:freenect_device], :pointer
  attach_function :freenect_set_depth_callback, [:freenect_device, :freenect_depth_cb], :void
  attach_function :freenect_set_video_callback, [:freenect_device, :freenect_video_cb], :void  
  attach_function :freenect_set_depth_format, [:freenect_device, DEPTH_FORMATS], :int
  attach_function :freenect_set_video_format, [:freenect_device, VIDEO_FORMATS], :int
  attach_function :freenect_set_depth_buffer, [:freenect_device, :pointer], :int
  attach_function :freenect_set_video_buffer, [:freenect_device, :pointer], :int
  attach_function :freenect_start_depth, [:freenect_device], :int
  attach_function :freenect_start_video, [:freenect_device], :int
  attach_function :freenect_stop_depth, [:freenect_device], :int
  attach_function :freenect_stop_video, [:freenect_device], :int
  attach_function :freenect_update_tilt_state, [:freenect_device], :int
  attach_function :freenect_get_tilt_state, [:freenect_device], RawTiltState
  attach_function :freenect_get_tilt_degs, [:freenect_device], :double
  attach_function :freenect_set_tilt_degs, [:freenect_device, :double], :int
  attach_function :freenect_set_led, [:freenect_device, LED_OPTIONS], :int
  attach_function :freenect_get_mks_accel, [RawTiltState, :pointer, :pointer, :pointer], :void

  begin
    attach_function :freenect_sync_get_videe, [:pointer, :pointer, :int, VIDEO_FORMATS], :int
    attach_function :freenect_sync_get_depth, [:pointer, :pointer, :int, DEPTH_FORMATS], :int
    attach_function :freenect_sync_stop, [], :void
    HAS_FREENECT_SYNC = true
  rescue FFI::NotFoundError
    warn "Your version of libfreenect does not have an up-to-date libfreenect_sync, you must upgrade if you wish to use the Sync features"
    HAS_FREENECT_SYNC = false
  end

end


