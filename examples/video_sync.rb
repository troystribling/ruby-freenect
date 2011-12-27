$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib")) << File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require 'freenect'
require 'tools'
require 'opengl'
include Gl,Glu,Glut

puts "Opening Kinect"
video_mode = Freenect.find_video_mode(:freenect_resolution_medium, :freenect_video_rgb)
depth_mode = Freenect.find_depth_mode(:freenect_resolution_medium, :freenect_depth_11bit)

print_video_mode(video_mode)

display = lambda do
  video_buffer = Freenect.get_video(video_mode)
	glClear(GL_COLOR_BUFFER_BIT)
  glColor(1.0, 1.0, 1.0)
  # glRasterPos2d(0, 0)
  # glPixelZoom(1, -1)
  glDrawPixels(640, 480, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, video_buffer)
  glutSwapBuffers()
end

reshape = lambda do |w, h|
	glViewport(0, 0, w,  h)
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	glOrtho(0, w, 0, h, -1.0, 1.0)
	glMatrixMode(GL_MODELVIEW)
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
glutIdleFunc(display)
glutReshapeFunc(reshape)
# glutKeyboardFunc(keyboard(device, context))
glutMainLoop()

