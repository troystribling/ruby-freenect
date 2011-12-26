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

keyboard = Proc.new do |key, x, y|
end

STDERR.puts "opening kinect"

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

