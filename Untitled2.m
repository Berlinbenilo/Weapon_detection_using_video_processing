load('DetectorGun.mat');

% Create a cascade detector object.
% Read a video frame and run the detector.
videoFileReader = vision.VideoFileReader('gun.mp4');
videoFrame      = step(videoFileReader);
% gray = rgb2gray(videoFrame);
bbox = step(DetectorGun, videoFrame);
% Draw the returned bounding box around the detected face.
videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');
figure, imshow(videoOut), title('Detected face');
% Get the skin tone information by extracting the Hue from the video frame
% converted to the HSV color space.
[hueChannel,~,~] = rgb2hsv(videoFrame);
% Display the Hue Channel data and draw the bounding box around the face.
figure, imshow(hueChannel), title('Hue channel data');
rectangle('Position',bbox(2,:),'LineWidth',2,'EdgeColor',[1 1 0])
% Detect the nose within the face region. The nose provides a more accurate
% measure of the skin tone because it does not contain any background
% pixels.
noseDetector = vision.CascadeObjectDetector('Nose');
faceImage    = imcrop(videoFrame,bbox(3,:));
noseBBox     = step(noseDetector, faceImage);
% The nose bounding box is defined relative to the cropped face image.
% Adjust the nose bounding box so that it is relative to the original video
% frame.
noseBBox(1,1:2) = noseBBox(1,1:2) + bbox(3,1:2);
% Create a tracker object.
tracker = vision.HistogramBasedTracker;
% Initialize the tracker histogram using the Hue channel pixels from the
% nose.
initializeObject(tracker, hueChannel, bbox(3,:));
% Create a video player object for displaying video frames.
videoInfo    = info(videoFileReader);
videoPlayer  = vision.VideoPlayer('Position',[200 200 600 800]);
% Track the face over successive video frames until the video is finished.
while ~isDone(videoFileReader)
% Extract the next video frame
videoFrame = step(videoFileReader);
% RGB -> HSV
[hueChannel,~,~] = rgb2hsv(videoFrame);
% Track using the Hue channel data
bbox = step(tracker, hueChannel);
% Insert a bounding box around the object being tracked
videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');
% Display the annotated video frame using the video player object
step(videoPlayer, videoOut);
x = bbox(1,1);
y = bbox(1,2);
w = bbox(1,4);
h = bbox(1,3);
if ((x+w)>1600 || (y+h)>1200)
    continue;
end
imwrite = videoFrame (y:(y+h),x:(x+w),:);
imshow(imwrite)
end
% Release resources
release(videoFileReader);
release(videoPlayer);