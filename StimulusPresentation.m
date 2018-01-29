function StimulusPresentation()
%  Stimulus presentation for virtual patients
% each stimulus is presented half a second with specific type of noise,
% asked to identify through *hopefully* voice recog
clear all
close all



% hardcoded parameters
%get parameters
p = GetParams();
% path = genpath; addpath(path);
%% Initialize Sound for Fixation Point Beep
[pahandle beep] = GetSound(p);

% Prompt participant info %
prompt={'Participant No:','Virtual Patients','stimType','respType', 'display'};
dlg_title = 'Parameters';
num_lines = 1;
defAns = {'0','1,2', 'l','keyboard', 'crt'};
options.Resize = 'on';
answer = inputdlg(prompt,dlg_title,num_lines,defAns,options);

p.sub.no = str2num(answer{1}); %participant no
p.vp = str2num(answer{2}); %virtual patients used    [letStim display list]  = ImgConv(p.stim.dir, dName);

p.stim.type = answer{3}; %type of stimlus
p.resp_type = answer{4}; % type of response
dName  = answer{5}; %type of display



% import stimulus
%if stimulus type is letters
if p.stim.type == 'l'
    [letStim display list]  = ImgConv(p.stim.dir, dName);
    p.display  = display;
    %number of trials is x10 permutated
    %number of trials is vpno*stimno*repetitions then shuffled
    [index randGen] = RandomizeOrder(size(letStim,3),p.stim.rep);
    p.rand = randGen;
end


%%
confArray = strings(size(index,2),2);
try
    p.display =OpenWindow(p.display);
    % stimulus presentation
    %show the stimulus for half a second on the screen randomly
    HideCursor();
    for j = 1: size(index,2)
        %Fixation Point
        PsychPortAudio('Start', pahandle, 1, p.beep.sCue, p.beep.wait);
        p.display = DrawFixation(p.display);
        WaitSecs(1);
        Screen('Flip', p.display.window)
        
        
        PsychPortAudio('Stop', pahandle);
        
        
        img = letStim(:,:,index(j));
        img = uint8(img / max(img(:)) * 255);
        tPtr = Screen('MakeTexture', p.display.window, img);
        Screen('DrawTexture', p.display.window, tPtr,[]);
        Screen('Flip', p.display.window);
        
        WaitSecs(p.stim.dur);
        
        Screen('FillRect',p.display.window,0)
        Screen('Flip',p.display.window)
        wait4key();
      
        Screen('FillRect',p.display.window,0)
        Screen('Flip',p.display.window)
        WaitSecs(1);
        
        
    end
   
    %convert data int json file
    data = jsonencode(p);
    %save the data
    
    save(['./responses/' num2str(p.sub.no) '.mat'] ,'p');
  
catch ME
    rethrow(ME)
    Screen('Close', p.display.window); ShowCursor();
end
Screen('Close', p.display.window); ShowCursor();

end
