function [string endFlag] = GetResponse(respType, wPtr, coords)
% get input from the participant using different modes.
% return response as strıng and the response time as ms
% EIY 10/17

%% Define Parameters %%
string ='';
endFlag = false;
switch respType
    case 'voice'
        
        %get user input via keyboard
        %things to consider is
        %what if the user presses the wrong key -> use backspace
        % user enters the key and then presses enter to return response
    case 'keyboard'
        % all operating systems:
        KbName('UnifyKeyNames');
        while true
            ListenChar(2);
            char = GetKbChar();
            if isempty(char)
                string = '';
                terminatorChar = 0;
                break;
            end
            
            switch abs(char)
                case {13,3,10 27}
                    % ctrl-C, enter, return, or escape
                  terminatorChar = abs(char);
                     break;
                                  
                case 8
                    % backspace
                    if ~isempty(string)
                        % Redraw text string, but with textColor == bgColor, so
                        % that the old string gets completely erased:
                        oldTextColor = Screen('TextColor', wPtr);
                        Screen('DrawText', wPtr, string, coords(1), coords(1), 0, 0);
                        Screen('TextColor', wPtr, oldTextColor);
                        % Remove last character from string:
                        string = string(1:length(string)-1);
                    end
                otherwise
                    string = [string, char];
                    Screen('DrawText', wPtr, string, coords(1), coords(2), 100, 0);
                    Screen('Flip', wPtr, 0, 1);
            end
            
        end
        ListenChar(1);
        
    otherwise
        
end
end

