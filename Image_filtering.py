#image filtering

import cv2 #OpenCV library for image and video processing.
import sys  #To handle command-line arguments.
import numpy #For numerical operations, especially on arrays.

#mode constants
PREVIEW=0 # preview mode
BLUR=1    #Blurring filter
FEATURES=2  #corner feature detector
CANNY=3    # canny edge detector
#Defines modes (filters) by assigning them a unique integer for internal use.

feature_params=dict(maxCorners=500,qualityLevel=0.2,minDistance=15,blockSize=9)
#maxCorners: Maximum number of corners to return.
#qualityLevel: Minimum accepted quality of corners,Corner quality threshold (lower = more corners).
#minDistance: Minimum distance between corners.
#blockSize: Size of neighborhood for corner detection or Neighborhood size used to compute corner quality.

image_filter=PREVIEW
alive=True
win_name="camera filters"
cv2.namedWindow(win_name,cv2.WINDOW_NORMAL)
result=None
source=cv2.VideoCapture(0)
#image_filter: starts in Preview mode.
#alive:controls the while loop for the camera feed
#cv2.namedWindow :creates a window
#cv2.VideoCapture(s): opens the video source.
#Reads a frame from the camera,has_frame is False if the read fails.Loop stops if video feed ends or fails.
while alive:
    has_frame, frame = source.read()
    if not has_frame:
        break
        
        frame=cv2.flip(frame,1) #Flips the frame horizontally, like a mirror

    if image_filter==PREVIEW:
        result=frame # shows raw image
    elif image_filter==CANNY:
        result=cv2.Canny(frame,80,150) #Applies Canny Edge Detection.
    elif image_filter==BLUR:
        result=cv2.blur(frame,(13,13))#Applies a blurring effect using a 13x13 kernel.

    elif image_filter==FEATURES:
        result=frame
        frame_gray=cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)
        corners=cv2.goodFeaturesToTrack(frame_gray,**feature_params)# goodzfeaturesToTrack():Finds up to 500 strong corners (edges).
        if corners is not None:
            for x,y in numpy.float32(corners).reshape(-1,2):
                #-1 tells NumPy to automatically figure out the number of rows (based on total elements).2 says each row should have two values: x and y.
                cv2.circle(result,(int(x),int(y)),10,(0,255,0),1)#Converts frame to grayscale.Detects corners.Draws green circles on detected corners.
    cv2.imshow(win_name,result)
    key = cv2.waitKey(1)
    if key == ord("Q") or key == ord("q") or key == 27:
        alive = False
    elif key == ord("C") or key == ord("c"):
        image_filter = CANNY
    elif key == ord("B") or key == ord("b"):
        image_filter = BLUR
    elif key == ord("F") or key == ord("f"):
        image_filter = FEATURES
    elif key == ord("P") or key == ord("p"):
        image_filter = PREVIEW

source.release()
cv2.destroyWindow(win_name)
