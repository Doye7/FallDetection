% Capture 10 frames
avgNum = 5;

start(vid);

% Wait to make sure its had time to capture - Un-needed
%pause(1);

% Take the data captured and put it into the matlab area
data = getdata(vid, avgNum);
% Initialise avgIm with the first frame
avgIm = double(data(:,:,:,1));

% Add the rest of the frames to the composite image
%use double to prevent matlab capping at 255
for i = 2:avgNum
    avgIm = avgIm + double(data(:,:,:,i));
end

% Turn it back into a uInt8 and divide by the number of frames for an
%average
avgIm = uint8(avgIm / avgNum);
%imshow(avgIm)