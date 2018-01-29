function p = SetParams(par,field, val)




prompt={'Participant No:','Virtual Patients','stimType','respType', 'display'};
dlg_title = 'Parameters';
num_lines = 1;
defAns = {'0','1,2', 'l','keyboard', 'crt'};
options.Resize = 'on';
answer = inputdlg(prompt,dlg_title,num_lines,defAns,options);

%set Participant number
par.sub.no = val;

%set Virtual patients
par
pNo = str2num(answer{1}); %participant no
vp = str2num(answer{2}); %virtual patients used
stimType = answer{3}; %type of stimlus
respType = answer{4}; % type of response
display  = answer{5}; %type of display



end