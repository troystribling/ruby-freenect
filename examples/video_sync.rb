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
  glDrawPixels(640, 480, GL_RGB, GL_UNSIGNED_BYTE, video_buffer)
  glutSwapBuffers()
end

glutInit
glutInitWindowSize(640, 480)
glutInitWindowPosition(100, 100)
glutCreateWindow($0)

glutDisplayFunc(display)
glutIdleFunc(display)
glutKeyboardFunc(sync_keyboard)
glutMainLoop

