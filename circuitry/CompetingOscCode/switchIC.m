function dy = switchIC(t,y,ghc,gsynicpd,gsynicin,geliclp,geliclg)

ny = length(y);
% initials conditions
N = y(1:5)';
H = y(6:10)';
Vm = y(11:15)';

gsyn.lp.pd = ghc; %uS
gsyn.lg.in = ghc;
gsyn.ic.pd = gsynicpd;
gsyn.ic.in = gsynicin;
gel.ic.lp = geliclp;
gel.ic.lg = geliclg;

% ionic conductances
gk(1)=0.039; gl(1)=0.0001; gc(1)=0.019; gh(1)=0.025; %f1
gk(2)=0.039; gl(2)=0.0001; gc(2)=0.019; gh(2)=0.025; %f2
gk(3)=0.019; gl(3)=0.0001; gc(3)=0.017; gh(3)=0.008; %hn
gk(4)=0.015; gl(4)=0.0001; gc(4)=0.0085; gh(4)=0.01; %s2
gk(5)=0.015; gl(5)=0.0001; gc(5)=0.0085; gh(5)=0.01; %s1

n = 5;
iext=zeros(1,n);

c=1; %nF
phi=0.002; %1/ms
vk=-80; %mV
vl=-40;
vca=100;
vh=-20;
vsyn=-75;
vp1=0;
vp2=20;
vp3=0;
vp4=15;
vp5=78.3;
vp6=10.5;
vp7=-42.2;
vp8=87.3;
vth=-25;
vp11=5;

minf=.5*(1+tanh((Vm-vp1)./vp2));
ninf=.5*(1+tanh((Vm-vp3)./vp4));
lamdn= phi.*cosh((Vm-vp3)./(2*vp4));
hinf=1./(1+exp((Vm+vp5)./vp6));
tauh=(272-((-1499)./(1+exp((-Vm+vp7)./vp8))));
%#syn from cell onto others
sinf=1./(1+exp((vth-Vm)./vp11));

ielec(1) = 0;
ielec(2) = gel.ic.lp*(Vm(2)-Vm(3));
ielec(3) = (gel.ic.lp*(Vm(3)-Vm(2)))+(gel.ic.lg*(Vm(3)-Vm(4)));
ielec(4) = gel.ic.lg*(Vm(4)-Vm(3));
ielec(5) = 0;

isyn(1) = (gsyn.lp.pd*sinf(2)*(Vm(1)-vsyn));
isyn(2) = (gsyn.lp.pd*sinf(1)*(Vm(2)-vsyn));
isyn(3) = (gsyn.ic.pd*sinf(1)*(Vm(3)-vsyn))+(gsyn.ic.in*sinf(5)*(Vm(3)-vsyn));
isyn(4) = (gsyn.lg.in*sinf(5)*(Vm(4)-vsyn));
isyn(5) = (gsyn.lg.in*sinf(4)*(Vm(5)-vsyn));

ica = gc.*minf.*(Vm-vca);
ik = gk.*N.*(Vm-vk);
ih = gh.*H.*(Vm-vh);
il = gl.*(Vm-vl); %nA

dy = zeros(ny,1);    % a column vector

dy(1:5) = lamdn.*(ninf-N); %dN
dy(6:10) = (hinf-H)./tauh; %dH
dy(11:15) = (iext-ica-il-ik-ih-ielec-isyn)./c; %dVm

end
