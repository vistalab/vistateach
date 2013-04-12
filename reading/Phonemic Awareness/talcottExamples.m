%
%

FS = 8192;  % Speaker sampling rate  (1/sec)
dT = 1/FS;  % Temporal sampling steps (sec)

toneDuration = 1.0;   % 75 ms
t = [0:dT:toneDuration];     % Time steps in sec

carrierF = 1000;
fmF = 2;
b = 0.5;


s1 = 0.7*sin(2*pi*carrierF*t);
allSounds = [];
for b = [10, 6, 3, 1, .3, 0]
    fprintf('FM modulation parameters %.1f\n',b);
    s2 = 0.7*sin(2*pi*carrierF*t +b*sin(2*pi*fmF*t));
    
    stimulusA = [s1(:)',blankSound(0.5,dT),s2(:)'];
    sound(stimulusA,FS); allSounds = [allSounds,stimulusA];
    
    pause(5); allSounds = [allSounds,blankSound(5,dT)];
end
wavwrite(allSounds,'TalcottFM2');

fmF = 240;
allSounds = [];
for b = [5, 3, 1, .3, 0]/120
    fprintf('FM modulation parameters %.1f\n',b);
    s2 = 0.7*sin(2*pi*carrierF*t +b*sin(2*pi*fmF*t));
    
    stimulusA = [s1(:)',blankSound(0.5,dT),s2(:)'];
    sound(stimulusA,FS); allSounds = [allSounds,stimulusA];
    
    pause(5); allSounds = [allSounds,blankSound(5,dT)];
end
wavwrite(allSounds,'TalcottFM240');