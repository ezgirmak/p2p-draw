function p = GetParams()

% Display parameters
%are specified at ImgConv

% Sounds parameters
p.beep.channels = 2;
p.beep.freq = 48000;
p.beep.length = 0.15;
p.beep.sCue = 0;
p.beep.wait = 1;

% % % General:
% % p.n_trials = 250;
% % p.break_trials = 50;
p.fixation_size = 5; %rad

% Stimuli
%general
p.stim.type = 'l';
p.stim.dir = './Stim/letters/'; %stimulus directory
p.stim.dur = 0.3; % seconds
p.stim.rep = 1; %no of repetitions 

%pulse2percept simulation related
p.stim.retina.decay = 3; %decay constant
p.stim.implant.type = 'argusII'; %implant type

%Subject
p.sub.no = 0;

%Virtual Patient
p.vp = [1 2];

%Response
p.resp_type = 'keyboard';
end