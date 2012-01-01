$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib")) << File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require 'freenect'
require 'tools'
require 'opengl'
include Gl,Glu,Glut

puts "#{Freenect.get_device_count} Kinect found"
video_mode = Freenect.find_video_mode(:freenect_video_rgb)

display = lambda do
  video_buffer = Freenect.get_video(video_mode)
  glPixelZoom(1.0, -1.0)
  glRasterPos2i(-1, 1)
  glDrawPixels(video_mode[:width], video_mode[:height], GL_RGB, GL_UNSIGNED_BYTE, video_buffer)
  glutSwapBuffers()
end

glutInit
glutInitWindowSize(video_mode[:width], video_mode[:height])
glutInitWindowPosition(100, 100)
glutCreateWindow($0)

glutDisplayFunc(display)
glutIdleFunc(display)
glutKeyboardFunc(sync_keyboard)

glClearColor(0.0, 0.0, 0.0, 0.0)
glClear(GL_COLOR_BUFFER_BIT)

glutMainLoop

