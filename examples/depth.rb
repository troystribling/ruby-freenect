$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib")) << File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require 'freenect'
require 'tools'
require 'opengl'
include Gl,Glu,Glut

puts "Opening Kinect"
depth_mode = Freenect.find_depth_mode(:freenect_depth_11bit)

display = lambda do
  depth_buffer = Freenect.get_depth(depth_mode)
  glPixelZoom(1.0, -1.0)
  glRasterPos2i(-1, 1)
  glDrawPixels(depth_mode[:width], depth_mode[:height], GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, depth_buffer)
  glutSwapBuffers()
end

glutInit
glutInitWindowSize(depth_mode[:width], depth_mode[:height])
glutInitWindowPosition(100, 100)
glutCreateWindow($0)

glutDisplayFunc(display)
glutIdleFunc(display)
glutKeyboardFunc(sync_keyboard)

glClearColor(0.0, 0.0, 0.0, 0.0)
glClear(GL_COLOR_BUFFER_BIT)

glutMainLoop
