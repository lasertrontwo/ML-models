# Real-Time Camera Filter Switcher using OpenCV

This is my first OpenCV project where I built a real-time camera feed app in Python. The app allows the user to switch between different image filters dynamically using keyboard input. It helped me learn how to use OpenCV's basic image processing functions and understand real-time video handling.

---

## Features

Live video capture using the webcam
Four filter modes:
Preview Mode – raw camera feed
Blur Mode – applies a 13x13 blurring filter
Feature Detection Mode – highlights corners using `cv2.goodFeaturesToTrack()`
Canny Edge Detection Mode – detects edges in real time
- Keyboard-controlled filter switching:
  - Press `P` – Preview mode
  - Press `B` – Blur filter
  - Press `F` – Feature detection (corner tracking)
  - Press `C` – Canny edge detection
  - Press `Q` or `ESC` – Exit the application

---

## What I Learned

- How to use `cv2.VideoCapture()` for real-time camera access
- How to apply image filters to live frames
- Drawing shapes (like circles) on frames
- Real-time keyboard interaction using `cv2.waitKey()`
- Understanding NumPy reshape and type conversion for OpenCV output

---

## Requirements

- Python 3.x
- OpenCV
- NumPy

