% Make a video object (inputName,deviceID,videoFormat)
vid = videoinput('winvideo', 1, 'RGB24_640x480');

% Set the output colour type
%vid.ReturnedColorSpace = 'grayscale';
vid.ReturnedColorSpace = 'rgb';

% Gets the currently active video input
src = getselectedsource(vid);

vid.FramesPerTrigger = 1;

frameRate = '10.0000';

% diasable all auto processing and set the framerate to 15
src.FocusMode = 'manual';
src.BacklightCompensation = 'off';
src.ExposureMode = 'manual';
%src.ExposureMode = 'auto';
src.WhiteBalanceMode = 'manual';
src.Exposure = -6;
src.FrameRate = frameRate;


vid.FramesPerTrigger = 5;
vid.FrameGrabInterval = 1;

% Add the path to the java file (working directory + name)
% Path is dynamic so as long as the javafile is in the WD it will work
javaaddpath(pwd + "\googleMailSend.jar")

% Create a new instance of the java file names javaCode
javaCode = googlemailsend.GoogleMailSend;

emailSubject = "Fall has been detected on camera one";
emailBody = "If the image shows a fall, send help to camera ones location and then reset the system";
emailPath = pwd + "\imageOut.png";

% Live window of the video
% D:\NetBeansProjects\GoogleMailSend\dist\GoogleMailSend.jar
% Get a still image from the camera and show it
%frame = getsnapshot(vid);
%imshow(frame);

