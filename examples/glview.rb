$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
require 'rubygems'
require 'freenect'
require 'opengl'
include Gl,Glu,Glut

display = Proc.new do
	glClear(GL_COLOR_BUFFER_BIT)
	glColor(1.0, 1.0, 1.0)

  # flip the image
  # glRasterPos2i(0, 480)
  #   glPixelZoom(1, -1)
  #   glDrawPixels(640, 480, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, $dev.depth_buffer)
  #   glRasterPos2i(640, 480)
  #   glDrawPixels(640, 480, GL_RGB, GL_UNSIGNED_BYTE, $dev.video_buffer)
  # glutSwapBuffers()
end

play = Proc.new do
end

reshape = Proc.new do |w, h|
	glViewport(0, 0, w,  h)
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	glOrtho(0, w, 0, h, -1.0, 1.0)
	glMatrixMode(GL_MODELVIEW)
end

puts "Opening Kinect"
device = Freenect.init.device
device.set_video_mode(Freenect.find_video_mode(:freenect_resolution_medium, :freenect_video_rgb))
device.set_depth_mode(Freenect.find_video_mode(:freenect_resolution_medium, :freenect_depth_11bit))

keyboard = Proc.new do |key, x, y|
	case (key.chr)
  when ('0'..'6')
    device.set_led key.chr.to_i
  when 'w'
    device.set_tilt (tilt = [25, tilt + 5].min)
  when 'x'
    device.set_tilt (tilt = [-25, tilt - 5].max)
  when 's'
    device.set_tilt (tilt = 0)
  when 'e'
    device.set_led :led_off
    device.stop_video
    device.stop_depth
    device.close
    exit(0)
	end
end

glutInit
glutInitDisplayMode(GLUT_RGBA | GLUT_DEPTH)
glutInitWindowSize(1280, 480)
glutInitWindowPosition(100, 100)
glutCreateWindow($0)

glPixelStorei(GL_UNPACK_ALIGNMENT, 1)
glClearColor(0.0, 0.0, 0.0, 0.0)
glDisable(GL_DITHER)

glutDisplayFunc(display)
glutReshapeFunc(reshape)
glutIdleFunc(play)
glutKeyboardFunc(keyboard)
glutMainLoop()

