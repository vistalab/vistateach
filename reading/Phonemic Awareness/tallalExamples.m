% From original Tallal and Piercy study
%

% dir = 'D:\brian\Matlab\VISTATEACH\Teaching\Phonemic Awareness';
% chdir(dir)

FS = 8192;  % Speaker sampling rate  (1/sec)
dT = 1/FS;  % Temporal sampling steps (sec)

toneDuration = 0.075;   % 75 ms
ISI = logspace(-2,-.5,3);% 10 ms to 300 ms sec

% Test frequency
f1 = 400;    % 100 and 305 Hz for this example
f2 = 800;    

t = [0:dT:toneDuration];     % Time steps in sec
tone1 = 0.7*sin(2*pi*f1*t)';
tone2 = 0.7*sin(2*pi*f2*t)';

% load handel
% sound(y,Fs)
% ii = 1

allSounds = [];
for ii=1:length(ISI)
    fprintf('ISI:  %.03f\n',ISI(ii));
    allSounds = [allSounds,blankSound(2,dT)];
    
    stimulusA = [tone1(:)',blankSound(ISI(ii),dT),tone2(:)'];
    % plot(stimulusA); xlabel('time (ms)'); ylabel('Sound pressure')

    stimulusB = [tone2(:)',blankSound(ISI(ii),dT),tone1(:)'];
    % plot(stimulusB); xlabel('time (ms)'); ylabel('Sound pressure')
    
    playList = sign(rand(1,10) - 0.5);
    
    for ii=1:length(playList)
        if playList(ii) < 1, sound(stimulusA,FS); allSounds = [allSounds,stimulusA];
        else                 sound(stimulusB,FS); allSounds = [allSounds,stimulusB];
        end
        pause(1.5);  allSounds = [allSounds,blankSound(1.5,dT)];
        
    end
    
    pause(3); allSounds = [allSounds,blankSound(3,dT)];
end

% Should we just make the whole track and write it out?
wavwrite(allSounds,'TallalPitch400');





