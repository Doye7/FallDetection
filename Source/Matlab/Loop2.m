% Preview the video to keep it fast
preview(vid);

imFig = figure('Position', [50,120,800,600]);
set(imFig, 'MenuBar', 'none');
set(imFig, 'ToolBar', 'none');

% Create simple UI elements
btnEnd = uicontrol('Style', 'pushbutton', 'String', 'End capture',...
    'Position', [20,20,70,20], 'Callback', 'loop = false;');

txtLowThreshold = uicontrol('Style','text',...
        'Position',[100,20,460,20], 'String','Threshhold: ');
    
txtFall = uicontrol('Style','text',...
        'Position',[100,5,460,20], 'String','Threshhold: ');
    
txtRatio = uicontrol('Style','text',...
        'Position',[480,20,160,20], 'String','Ratio:  ');


% Get the resolution of the capture
quickFrame = getsnapshot(vid);
frameSize = size(quickFrame);

% Choose the percent to trigger true
lowThresholdPercent = 1;
highThresholdPercent = 50;
lowBooleanChange = false;

% Get the number of pixels in the capture and create, based on the percent
%a number of pixels to exceed
pixelCount = numel(quickFrame) / 3;
lowPixelThreshold = (pixelCount / 100) * lowThresholdPercent;
highPixelThreshold = (pixelCount / 100) * highThresholdPercent;

% Create a strucural element for erosion / closing
seErodeSize = 5;
seCloseSize = 5;
seErode = strel('square', seErodeSize);
seClose = strel('square', seCloseSize);

% Calculate the number of frames will have passed in the specified time
% (fps * time)
framesForAverage = (10 * 60);
fallFrames = 0;
fallDetected = false;
sendAlert = false;
% Get an average of multiple images
GetAverage;

% Make the display window
%video = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);

% Un-needed?
%video2 = vision.VideoPlayer('Position', [750 100 [frameSize(2), frameSize(1)]+30]);

loop = true;
frameCount = 1;

while loop
    % -------------------------LEGACY--------------------------------
    % Get a frame
    %currentframe = getsnapshot(vid);
    
    % Anything lighter than the background shows
    %currentframe = getsnapshot(vid) - avgIm;
    
    % Anything darker than the background shows
    %currentframe = avgIm - getsnapshot(vid);
    
    % ----------------------------------------------------------------
    
    % Anything darker or lighter than the background test
    % Get the frame and convert it into a double to allow negetives
    baseImage = getsnapshot(vid);
    currentDouble = double(baseImage) + 1;
    
    % Subtract the average image from it, then take the absolute value and
    % convert that back into uint8 format
    currentFrame = uint8(abs(currentDouble - double(avgIm)+1)) -1;
    
    % Binary1 = im2bw(currentframe, 0.1);
    
    % Very low threshold since its for detecting change
    %imOut = im2bw(currentFrame, 0.05);
    imOut = im2bw(currentFrame, 0.15);
    
    % Erode / Close
     %imOut = imcomplement(imOut);
     %imOut = imerode(imOut, seErode);
     imOut = imclose(imOut,seClose);
    % imOut = imcomplement(imOut);
    
    % If the number of white pixels exceeds the threshold, then true
    totalWhite = sum(sum(imOut));
    lowBooleanChange = totalWhite > lowPixelThreshold;
    highBooleanChange = totalWhite > highPixelThreshold;
    
    label = bwlabel(imOut);
    props = regionprops(label, 'Centroid', 'BoundingBox', 'Area');
    
    % Get the location of the maximum area in a transposed props matrix
    areaOfBox = [props.Area]';
    
    % Area value is uneeded, only location is required
    [areaValue,areaLocation] = max(areaOfBox);
    
    % Add the new frame to the window and update it
    %step(video, Binary1);
    figure(imFig);
    
    % step(video2, imOut);
    imshow(imOut);
    isPropsEmpty = isempty(props);
    % If the props array has values and the threshold is reached
    if not(isPropsEmpty) && lowBooleanChange
        % Using the location of the maximum area, get the coordinates of the
        % largest bounding box and its centre
        boxCoords = props(areaLocation).BoundingBox;
        centerCoords = props(areaLocation).Centroid;
        
        % To draw box
        % Rectangle position syntax, topleftX topleftY, Width, Height
        rectangle('Position', boxCoords, 'EdgeColor', 'red');
        % To draw Spot
        viscircles(centerCoords,2);
        
        % Get the ratio of the bounding box to determine the persons
        % position reletive to the ground and camera
        boxRatio = boxCoords(4) / boxCoords(3);
        
        txtRatio.String = "Ratio: " + boxRatio;
        
        % if the bounds are greater in width than in hight
        if boxRatio < 0.9
            % Mark a detection and begin counting frames
            fallDetected = true;
            fallFrames = fallFrames + 1;
            
            % If the person has not moved to an upright position in 10
            % seconds warn send a warning email and close the program
            if fallFrames > 100
                sendAlert = true;
                imwrite(baseImage, 'imageOut.png');
                % Syntax - Senders email, Senders Password, Destination
                % email, email subject, email text and path for attachment
                % image
                javaCode.SendMail(emailSource, emailPassword, emailDestination, emailSubject, emailBody, emailPath);
                loop = false;
            else
            end
        else
            fallDetected = false;
            if fallFrames > 0
            fallFrames = fallFrames -1;
            else
            end
            sendAlert = false;
        end
    else

    end
    txtLowThreshold.String = "Low Threshold Reached: " + lowBooleanChange + "   Send alert? " + sendAlert;
    txtFall.String = "High Threshold Reached: " + highBooleanChange + "   Frames since detection: " + fallFrames;
    
    % if the upper pixel threshold is reached OR if a specified ammount of
    % time has passed get a new average. If the time triggered, only get a
    % new average if there is not currently an object in view
    if highBooleanChange || ((mod(frameCount, framesForAverage) == 0) && not(lowBooleanChange))...
            || ((frameCount ./ framesForAverage) > 5)
        %pause(1);
        frameCount = 1;
        GetAverage();
        
    else
    end
    
    % End the loop and close all windows if loop becomes False
    
    if loop
    else
        close all;
        closepreview;
    end
    
    frameCount = frameCount + 1;
end

