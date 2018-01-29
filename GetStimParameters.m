%stim =GetStimParameters(sName)
%Gets stimulus parameters from the naming of the image, mostly hardcoded

function stim =GetStimParameters(sName)
load('LUT.mat');
pars = strsplit(sName,{'/','_', '.'});

stim.mode = pars{1};
stim.name = pars{2};

lut = str2num(pars{3});
%look up Look Up Table to get parametervalues
% for i = 1: size(LUT,2)
%     stim.
% end

stim.lut = lut;
end