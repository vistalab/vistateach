function [time,Vmemb] = switchICg_leak3_ode45(ghc,gsynicpd,gsynicin,geliclp,geliclg,trange,y0)
% [time,Vmemb,Nt,Ht] = switchICg_leak3_ode45(ghc,gsynicpd,gsynicin,geliclp,geliclg,trange,y0)

[T,Y] = ode45(@(t,y) switchIC(t,y,ghc,gsynicpd,gsynicin,geliclp,geliclg),trange,y0);

time = 1e-3.*T; %seconds
% Nt = Y(:,1:5);
% Ht = Y(:,6:10);
Vmemb = Y(:,11:15);

end