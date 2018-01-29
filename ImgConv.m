function [letStim display stimPars] =  ImgConv(directory, dName)
% Converts given image to 10x17 rad image for the given display that has
% width, distance and resolution properties
% uses function angle2pix by GB and KC
% Written by EIY, Nov 17'

% Wanted visual degree
x = 10;
y = 17;

%%choose the monitor
if dName == "crs"
    display.dist  = 50;
    display.width = 75.184; %cm
    display.resolution   =  [1920 1080] ; %resolution
    display.rrate = 120; % to be changed
elseif dName == "crt"
    display.dist= 52; %cm
    display.width =  35.56;  %cm
    display.resolution   =[1024  768];
    display.rrate = 60; 

end

%get the required size
pixX = angle2pix(display, x);
pixY = angle2pix(display,y);

%% modify stimulus
oldFolder  = cd(directory);
%list the contents
temp = dir; list = temp(3:end); list = {list.name};
lSize = size(list,2);

%create stimulus array
%generate an ardray of zeros with the number of stimuli
letStim = zeros(pixX,pixY,lSize);

%%
for i = 1:lSize
    % read the image
    tImg = imread(char(list(i))); 
    tImg= imresize(tImg, [pixX pixY]);
    stimPars(i)= GetStimParameters(char(list(i)));      
    %add to array
    letStim(:,:,i) = tImg;
    %imwrite(tImg, 'resized.png')
end

cd(oldFolder);

end
