$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
require 'rubygems'
require 'freenect'
require 'opengl'
include Gl,Glu,Glut

puts "Opening Kinect"
context = Freenect.init
tilt = 0
device = context.get_device
context.set_log_level(:freenect_log_warning)
device.set_video_mode(Freenect.find_video_mode(:freenect_resolution_medium, :freenect_video_rgb))
device.set_depth_mode(Freenect.find_depth_mode(:freenect_resolution_medium, :freenect_depth_11bit))
device.set_tilt(0)
device.start_video
device.start_depth

display = lambda do
	glClear(GL_COLOR_BUFFER_BIT)
	glColor(1.0, 1.0, 1.0)
  glRasterPos2i(0, 480)
  glPixelZoom(1, -1)
  glDrawPixels(640, 480, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, device.depth_buffer)
  glutSwapBuffers()
end

play = lambda do
  glutPostRedisplay() if context.process_events >= 0
end

reshape = lambda do |w, h|
	glViewport(0, 0, w,  h)
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	glOrtho(0, w, 0, h, -1.0, 1.0)
	glMatrixMode(GL_MODELVIEW)
end

keyboard = lambda do |key, x, y|
	case (key.chr)
  when ('0'..'5')
    device.set_led Freenect::FREENECT_LED_OPTIONS.symbols[key.chr.to_i]
  when 'u'
    device.set_tilt (tilt = [25, tilt + 5].min)
  when 'd'
    device.set_tilt (tilt = [-25, tilt - 5].max)
  when 'c'
    device.set_tilt (tilt = 0)
  when 'e'
    device.set_led :led_off
    device.set_tilt (tilt = 0)
    device.stop_video
    device.stop_depth
    context.close
    puts "Closing Kinect"
    exit(0)
	end
end

glutInit
glutInitDisplayMode(GLUT_RGBA | GLUT_DEPTH)
glutInitWindowSize(640, 480)
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

