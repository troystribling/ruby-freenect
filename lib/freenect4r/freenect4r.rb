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
    :freenect_resolution_dummy,  2147483647   # Dummy value to force enum to be 32 bits wide
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
  class FreenectFrameMode < FFI::Struct
    layout :reserved,               :uint32,             # unique ID used internally.  The meaning of values may change without notice.  
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
                              
  # Enumeration of tilt motor status
  FREENECT_TILT_STATUS_CODE =  enum(
  	:tilt_status_stopped, 0x00, # Tilt motor is stopped
  	:tilt_status_limit,   0x01, # Tilt motor has reached movement limit
  	:tilt_status_moving,  0x04  # Tilrequire 'ffi't motor is currently moving to new position
  )

  class FreenectRawTiltState < FFI::Struct
    layout :accelerometer_x,  :int16_t,                  # Raw accelerometer data for X-axis, see FREENECT_COUNTS_PER_G for conversion
           :accelerometer_y,  :int16_t,                  # Raw accelerometer data for Y-axis, see FREENECT_COUNTS_PER_G for conversion
           :accelerometer_z,  :int16_t,                  # Raw accelerometer data for Z-axis, see FREENECT_COUNTS_PER_G for conversion
           :tilt_angle,       :int8_t,                   # Raw tilt motor angle encoder information 
           :tilt_status,      FREENECT_TILT_STATUS_CODE  # State of the tilt motor (stopped, moving, etc...)
  end
   
  typedef :pointer, :freenect_context     # Holds information about the usb context
  typedef :pointer, :freenect_device      # Holds device information.
  typedef :pointer, :freenect_usb_context # Holds libusb-1.0 specific information
 
  # Enumeration of message logging levels
  FREENECT_LOGLEVEL = enum( 
    :freenect_log_fatal,   0, # Log for crashing/non-recoverable errors
    :freenect_log_error,   1, # Log for major errors
    :freenect_log_warning, 2, # Log for warning messages
    :freenect_log_notice,  3, # Log for important messages
    :freenect_log_info,    3, # Log for normal messages
    :freenect_log_debug,   5, # Log for useful development messages
    :freenect_log_spew,    6, # Log for slightly less useful messages
    :freenect_log_flood,   7  # Log EVERYTHING. May slow performance.
  )
 
  # Initialize a freenect context and do any setup required for
  # platform specific USB libraries.
  #
  # @param ctx Address of pointer to freenect context struct to allocate and initialize
  # @param usb_ctx USB context to initialize. Can be NULL if not using multiple contexts.
  #
  # @return 0 on success, < 0 on error
  attach_function :freenect_init, [:freenect_context, :freenect_usb_context], :int

  # Closes the device if it is open, and frees the context
  #
  # @param ctx freenect context to close/free
  #
  # @return 0 on success
  attach_function :freenect_shutdown, [:freenect_context], :int

  # Set the log level for the specified freenect context
  #
  # @param ctx context to set log level for
  # @param level log level to use (see freenect_loglevel enum)
  attach_function :freenect_set_log_level, [:freenect_context, FREENECT_LOGLEVEL], :void

  # Callback for log messages (i.e. for rerouting to a file instead of
  # stdout)
  #
  # @param ctx context to set log callback for
  # @param cb callback function pointer
  callback :freenect_log_cb, [:freenect_context, FREENECT_LOGLEVEL, :string], :void
  attach_function :freenect_set_log_callback, [:freenect_context, :freenect_log_cb], :void
  
  # Calls the platform specific usb event processor
  #
  # @param ctx context to process events for
  #
  # @return 0 on success, other values on error, platform/library dependant
  attach_function :freenect_process_events, [:freenect_context], :int
  
  # Return the number of kinect devices currently connected to the
  # system
  #
  # @param ctx Context to access device count through
  #
  # @return Number of devices connected, < 0 on error
  attach_function :freenect_num_devices, [:freenect_context], :int
  
  # Set which subdevices any subsequent calls to freenect_open_device()
  # should open.  This will not affect devices which have already been
  # opened.  The default behavior, should you choose not to call this
  # function at all, is to open all supported subdevices - motor, cameras,
  # and audio, if supported on the platform.
  #
  # @param ctx Context to set future subdevice selection for
  # @param subdevs Flags representing the subdevices to select
  attach_function :freenect_select_subdevices, [:freenect_context, FREENECT_DEVICE_FLAGS], :void
  
  # Opens a kinect device via a context. Index specifies the index of
  # the device on the current state of the bus. Bus resets may cause
  # indexes to shift.
  #
  # @param ctx Context to open device through
  # @param dev Device structure to assign opened device to
  # @param index Index of the device on the bus
  #
  # @return 0 on success, < 0 on error
  attach_function :freenect_open_device, [:freenect_context, :freenect_device, :int], :int  
  
  # Closes a device that is currently open
  #
  # @param dev Device to close
  #
  attach_function :freenect_close_device, [:freenect_device], :int
  
  # Set the device user data, for passing generic information into
  # callbacks
  #
  # @param dev Device to attach user data to
  # @param user User data to attach
  attach_function :freenect_set_user, [:freenect_device, :pointer], :void
  
  # Retrieve the pointer to user data from the device struct
  #
  # @param dev Device from which to get user data
  #
  # @return Pointer to user data
  attach_function :freenect_get_user, [:freenect_device], :pointer
  
  # Set callback for depth information received event
  #
  # @param dev Device to set callback for
  # @param cb Function pointer for processing depth information
  callback :freenect_depth_cb, [:freenect_device, :pointer, :uint32], :void
  attach_function :freenect_set_depth_callback, [:freenect_device, :freenect_depth_cb], :void
  
  # Set callback for video information received event
  #
  # @param dev Device to set callback for
  # @param cb Function pointer for processing video information
  callback :freenect_video_cb, [:freenect_device, :pointer, :uint32], :void
  attach_function :freenect_set_video_callback, [:freenect_device, :freenect_video_cb], :void  
  
  # Set the buffer to store depth information to. Size of buffer is
  # dependant on depth format. See FREENECT_DEPTH_*_SIZE defines for
  # more information.
  #
  # @param dev Device to set depth buffer for.
  # @param buf Buffer to store depth information to.
  attach_function :freenect_set_depth_buffer, [:freenect_device, :pointer], :int

  # Set the buffer to store depth information to. Size of buffer is
  # dependant on video format. See FREENECT_VIDEO_*_SIZE defines for
  # more information.
  #
  # @param dev Device to set video buffer for.
  # @param buf Buffer to store video information to.
  #
  # @return 0 on success, < 0 on error
  attach_function :freenect_set_video_buffer, [:freenect_device, :pointer], :int

  # Start the depth information stream for a device.
  #
  # @param dev Device to start depth information stream for.
  #
  # @return 0 on success, < 0 on error
  attach_function :freenect_start_depth, [:freenect_device], :int

  # Start the video information stream for a device.
  #
  # @param dev Device to start video information stream for.
  #
  # @return 0 on success, < 0 on error
  attach_function :freenect_start_video, [:freenect_device], :int

  # Stop the depth information stream for a device
  #
  # @param dev Device to stop depth information stream on.
  #
  # @return 0 on success, < 0 on error
  attach_function :freenect_stop_depth, [:freenect_device], :int

  # Stop the video information stream for a device
  #
  # @param dev Device to stop video information stream on.
  #
  # @return 0 on success, < 0 on error
  attach_function :freenect_stop_video, [:freenect_device], :int

  # Updates the accelerometer state using a blocking control message
  # call.
  #
  # @param dev Device to get accelerometer data from
  #
  # @return 0 on success, < 0 on error. Accelerometer data stored to
  # device struct.
  attach_function :freenect_update_tilt_state, [:freenect_device], :int

  # Retrieve the tilt state from a device
  #
  # @param dev Device to retrieve tilt state from
  #
  # @return The tilt state struct of the device
  attach_function :freenect_get_tilt_state, [:freenect_device], FreenectRawTiltState

  # Return the tilt state, in degrees with respect to the horizon
  #
  # @param state The tilt state struct from a device
  #
  # @return Current degree of tilt of the device
  attach_function :freenect_get_tilt_degs, [FreenectRawTiltState], :double

  # Set the tilt state of the device, in degrees with respect to the
  # horizon. Uses blocking control message call to update
  # device. Function return does not reflect state of device, device
  # may still be moving to new position after the function returns. Use
  # freenect_get_tilt_status() to find current movement state.
  #
  # @param dev Device to set tilt state
  # @param angle Angle the device should tilt to
  #
  # @return 0 on success, < 0 on error.
  attach_function :freenect_set_tilt_degs, [:freenect_device, :double], :int

  # Return the movement state of the tilt motor (moving, stopped, etc...)
  #
  # @param state Raw state struct to get the tilt status code from
  #
  # @return Status code of the tilt device. See
  # freenect_tilt_st:freenect_get_tilt_statusatus_code enum for more info.
  attach_function :freenect_get_tilt_status, [FreenectRawTiltState], FREENECT_TILT_STATUS_CODE
  
  # Set the state of the LED. Uses blocking control message call to
  # update device.
  #
  # @param dev Device to set the LED state
  # @param option LED state to set on device. See freenect_led_options enum.
  #
  # @return 0 on success, < 0 on error
  attach_function :freenect_set_led, [:freenect_device, FREENECT_LED_OPTIONS], :int

  # Get the axis-based gravity adjusted accelerometer state, as laid
  # out via the accelerometer data sheet, which is available at
  #
  # http://www.kionix.com/Product%20Sheets/KXSD9%20Product%20Brief.pdf
  #
  # @param state State to extract accelerometer data from
  # @param x Stores X-axis accelerometer state
  # @param y Stores Y-axis accelerometer state
  # @param z Stores Z-axis accelerometer state
  attach_function :freenect_get_mks_accel, [FreenectRawTiltState, :pointer, :pointer, :pointer], :void

  # Get the number of video camera modes supported by the driver.  This includes both RGB and IR modes.
  #
  # @return Number of video modes supported by the driver
  attach_function :freenect_get_video_mode_count, [], :int

  # Get the frame descriptor of the nth supported video mode for the
  # video camera.
  #
  # @param n Which of the supported modes to return information about
  #
  # @return A freenect_frame_mode describing the nth video mode
  attach_function :freenect_get_video_mode, [:int], FreenectFrameMode
  
  # Sets the current video mode for the specified device.  If the
  # freenect_frame_mode specified is not one provided by the driver
  # e.g. from freenect_get_video_mode() or freenect_find_video_mode()
  # then behavior is undefined.  The current video mode cannot be
  # changed while streaming is active.
  #
  # @param dev Device for which to set the video mode
  # @param mode Frame mode to set
  #
  # @return 0 on success, < 0 if error
  attach_function :freenect_set_video_mode, [:freenect_device, FreenectFrameMode], :int

  # Get the number of depth camera modes supported by the driver.  This includes both RGB and IR modes.
  #
  # @return Number of depth modes supported by the driver
  attach_function :freenect_get_depth_mode, [:int], FreenectFrameMode
  
  # Get the frame descriptor of the current depth mode for the specified
  # freenect device.
  #
  # @param dev Which device to return the currently-set depth mode for
  #
  # @return A freenect_frame_mode describing the current depth mode of the specified device
  attach_function :freenect_get_current_depth_mode, [:freenect_device], FreenectFrameMode
  
  # Convenience function to return a mode descriptor matching the
  # specified resolution and depth camera pixel format, if one exists.
  #
  # @param res Resolution desired
  # @param fmt Pixel format desired
  #
  # @return A freenect_frame_mode that matches the arguments specified, if such a valid mode exists; otherwise, an invalid freenect_frame_mode.
  attach_function :freenect_find_depth_mode, [FREENECT_RESOLUTION, FREENECT_DEPTH_FORMAT], FreenectFrameMode
  
  # Sets the current depth mode for the specified device.  The mode
  # cannot be changed while streaming is active.
  #
  # @param dev Device for which to set the depth mode
  # @param mode Frame mode to set
  #
  # @return 0 on success, < 0 if error
  attach_function :freenect_set_depth_mode, [:freenect_device, FreenectFrameMode], :int

end


