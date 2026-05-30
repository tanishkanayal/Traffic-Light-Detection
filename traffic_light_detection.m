clc; 
clear; 
% Load input video 
inputVideo = 'traffic_light_video.mp4';  % Your input video 
video = VideoReader(inputVideo); 
% Create output video writer with increased frame rate for fast playback 
outputVideo = VideoWriter('output_detection_fast.mp4', 'MPEG-4'); 
outputVideo.FrameRate = 2 * video.FrameRate;  % 🔥 Double the playback speed 
open(outputVideo); 
% Frame skipping for speed 
frameSkip = 2; 
% Threshold for color detection (adjust as needed) 
pixelThreshold = 0.0005; 
% Show output window 
hFig = figure('Visible', 'on'); 
while hasFrame(video) 
% Read current frame 
frame = readFrame(video); 
% Skip frames to speed up processing 
for i = 1:frameSkip-1 
if hasFrame(video) 
readFrame(video); 
end 
end 
% Resize for faster processing 
frame = imresize(frame, 0.5); 
% Convert to HSV color space 
hsv = rgb2hsv(frame); 
h = hsv(:,:,1); s = hsv(:,:,2); v = hsv(:,:,3); 
% Define color masks 
redMask    
= (h > 0.95 | h < 0.05) & s > 0.4 & v > 0.4; 
yellowMask = (h > 0.12 & h < 0.18) & s > 0.45 & v > 0.5; 
greenMask  = (h > 0.25 & h < 0.45) & s > 0.3 & v > 0.3; 
% Calculate ratio of color pixels 
totalPixels = numel(h); 
redRatio    
= sum(redMask(:)) / totalPixels; 
yellowRatio = sum(yellowMask(:)) / totalPixels; 
greenRatio  = sum(greenMask(:)) / totalPixels; 
% Detection logic 
if redRatio > pixelThreshold && yellowRatio > pixelThreshold 
label = '🔴🟡 Red & Yellow Lights Detected'; 
labelColor = [1, 0.55, 0]; 
28 
elseif redRatio > pixelThreshold 
label = '🔴 Red Light Detected'; 
labelColor = [1, 0, 0]; 
elseif yellowRatio > pixelThreshold 
label = '🟡 Yellow Light Detected'; 
labelColor = [1, 1, 0]; 
elseif greenRatio > (pixelThreshold * 0.6)  % More sensitive to green 
label = '🟢 Green Light Detected'; 
labelColor = [0, 1, 0]; 
else 
label = '⚠️ No Traffic Light Detected'; 
labelColor = [0, 0, 0]; 
end 
% Show frame with label 
imshow(frame); 
text(10, 20, label, 'Color', labelColor, 'FontSize', 16, ... 
'FontWeight', 'bold', 'BackgroundColor', 'white'); 
% Capture and write the frame 
frameWithText = getframe(gca); 
writeVideo(outputVideo, frameWithText.cdata); 
end 
% Close everything 
close(outputVideo); 
close(hFig); 
disp('✅ Video processing complete. Output saved as output_detection_fast.mp4');
