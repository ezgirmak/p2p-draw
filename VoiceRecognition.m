function recordedaudio  = VoiceRecognition(name, trigger, secs)
%voice recognition response mode, adapted Mario Kleiner's
%BasicSoundInpuDemo for our needs, comments mostly his

% Running on PTB-3? Abort otherwise. MK 
AssertOpenGL;

% Filename provided?
if nargin < 1
    name = [];
end

if nargin < 2
    trigger = [];
end

if isempty(trigger)
    trigger = 0;
end

if nargin < 3
    secs = [];
end

if isempty(secs)
    secs = inf;
end


% Wait for release of all keys on keyboard:
while KbCheck; end;


% Perform basic initialization of the sound driver:
InitializePsychSound;

% Open the default audio device [], with mode 2 (== Only audio capture),
% and a required latencyclass of zero 0 == no low-latency mode, as well as
% a frequency of 44100 Hz and 2 sound channels for stereo capture.
% This returns a handle to the audio device:
freq = 44100;
pahandle = PsychPortAudio('Open', [], 2, 0, freq, 2);
% Preallocate an internal audio recording  buffer with a capacity of 10 seconds:
PsychPortAudio('GetAudioData', pahandle, 10);


% Start audio capture immediately and wait for the capture to start.
% We set the number of 'repetitions' to zero,
% i.e. record until recording is manually stopped.
PsychPortAudio('Start', pahandle, 0, 0, 1);


% Want to start via VoiceTrigger?
if trigger > 0
    % Yes. Fetch audio data and check against threshold:
    level = 0;
    
    % Repeat as long as below trigger-threshold:
    while level < trigger
        % Fetch current audiodata:
        [audiodata offset overflow tCaptureStart] = PsychPortAudio('GetAudioData', pahandle);

        % Compute maximum signal amplitude in this chunk of data:
        if ~isempty(audiodata)
            level = max(abs(audiodata(1,:)));
        else
            level = 0;
        end
        
        % Below trigger-threshold?
        if level < trigger
            % Wait for a millisecond before next scan:
            WaitSecs(0.0001);
        end
    end

    % Ok, last fetched chunk was above threshold!
    % Find exact location of first above threshold sample.
    idx = min(find(abs(audiodata(1,:)) >= trigger)); %#ok<MXFND>
        
    % Initialize our recordedaudio vector with captured data starting from
    % triggersample:
    recordedaudio = audiodata(:, idx:end);
%     [audiodata offset overflow capturestart]= PsychPortAudio('GetAudioData', painput);

%     % For the fun of it, calculate signal onset time in the GetSecs time:
%     % Caution: For accurate and reliable results, you should
%     % PsychPortAudio('Open',...); the device in low-latency mode, as
%     % opposed to the "normal" mode used in this demo! If you fail to do so,
%     % the tCaptureStart timestamp may be inaccurate on some systems, and
%     % therefore this tOnset timestamp may be off! See for example
%     % PsychPortAudioTimingTest and AudioFeedbackLatencyTest for how to
%     % setup low-latency high precision mode.
    tOnset = tCaptureStart + ((offset + idx - 1) / freq);

    fprintf('Estimated signal onset time is %f secs, this is %f msecs after start of capture.\n', tOnset, (tOnset - tCaptureStart)*1000);
else
    % Start with empty sound vector:
    recordedaudio = [];
end

% We retrieve status once to get access to SampleRate:
s = PsychPortAudio('GetStatus', pahandle);

% Stay in a little loop until keypress:
while ~KbCheck && ((length(recordedaudio) / s.SampleRate) < secs)
    % Wait a second...
    WaitSecs(1);
    
    % Query current capture status and print it to the Matlab window:
    s = PsychPortAudio('GetStatus', pahandle);
    
    % Print it:
    fprintf('\n\nAudio capture started, press any key for about 1 second to quit.\n');
    fprintf('This is some status output of PsychPortAudio:\n');
    disp(s);
    
    % Retrieve pending audio data from the drivers internal ringbuffer:
    audiodata = PsychPortAudio('GetAudioData', pahandle);
    nrsamples = size(audiodata, 2);
    
    % Plot it, just for the fun of it:
    plot(1:nrsamples, audiodata(1,:), 'r', 1:nrsamples, audiodata(2,:), 'b');
    drawnow;
    
    % And attach it to our full sound vector:
    recordedaudio = [recordedaudio audiodata]; %#ok<AGROW>
end

% Stop capture:
PsychPortAudio('Stop', pahandle);

% Perform a last fetch operation to get all remaining data from the capture engine:
audiodata = PsychPortAudio('GetAudioData', pahandle);

% Attach it to our full sound vector:
recordedaudio = [recordedaudio audiodata];

% Close the audio device:
PsychPortAudio('Close', pahandle);

% Replay recorded data: Open default device for output, push recorded sound
% data into its output buffer:
pahandle = PsychPortAudio('Open', [], 1, 0, 44100, 2);
PsychPortAudio('FillBuffer', pahandle, recordedaudio);

% Start playback immediately, wait for start, play once:
PsychPortAudio('Start', pahandle, 1, 0, 1);

% Wait for end of playback, then stop engine:
PsychPortAudio('Stop', pahandle, 1);

% Close the audio device:
PsychPortAudio('Close', pahandle);

% Shall we store recorded sound to wavfile?
if ~isempty(name)
    psychwavwrite(transpose(recordedaudio), 44100, 16, name)
end

% Done.
fprintf('Demo finished, bye!\n');

end
