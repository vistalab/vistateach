clear all

n = 5;
endtr = 600*1e3;
clipt = -55*1e3;
thr = 0;

% ghc = 0.0025;
ghc = 0.005;
% ghc = 0.01;

gel = 0:0.00025:0.0075;
gsyn = 0:0.00025:0.01;
lgel = length(gel);
lgsyn = length(gsyn);

N0 = zeros(1,n);
H0 = zeros(1,n);

mfrq = zeros(lgel,lgsyn,n);

for i = 1:lgel
    gelec = gel(i);
    for j = 1:lgsyn
        gsynA = gsyn(j);
        randinit = 0.1*(rand(1,n)-0.5); %+/- 0.05
        Vm0 = -65+randinit;
        y0 = [N0 H0 Vm0];
        [time,Vm] = switchICg_leak3_ode45(ghc,gsynA,gsynA,gelec,gelec,[0 endtr],y0);
        Vs = Vm(time>=0,:);
        t = time(time>=0);
        [mfrq(i,j,:),~] = humpfreq(Vs,t,thr);
    end
end

save('mfrq_gsynA_gel_circ_ode45.mat','mfrq','gel','gsyn','ghc')

