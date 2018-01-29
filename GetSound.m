function [pahandle myBeep]= GetSound(p)


%% Initialize Sound for Fixation Point Beep
% Initialize Sounddriver
InitializePsychSound(1);
% Number of channels and Frequency of the sound
pahandle = PsychPortAudio('Open', [], 1, 1, p.beep.freq, p.beep.channels);

% Make a beep which we will play back to the user
myBeep = MakeBeep(500, p.beep.length, p.beep.freq);
PsychPortAudio('FillBuffer', pahandle, [myBeep; myBeep]);
end