clear all
load('mfrq_gsynA_gel_circ_ode45.mat') %'mfrq','gel','gsyn','ghc'

%%
[ge,gs,m] = size(mfrq);
lw = 0.2; % default = 0.5

cind = round(100.*mfrq)+1; %color index
topc = max(max(max(cind)));

figure;
hold on

%% create colormap

if topc > 101 && topc < 110
    cmap = colormap(jet(111));
elseif topc > 110
    cmap = colormap(jet(121));
else
    cmap = colormap(jet(101));
end

cmap(1,:)=[1 1 1]; % makes 0Hz white

%% plot circuit frequencies on parameterscape
for a = 1:ge
    for b = 1:gs
        plot(gsyn(b),gel(a),'o','MarkerSize',25,'LineWidth',lw,'MarkerFaceColor',cmap(cind(a,b,1),:))
        plot(gsyn(b),gel(a),'o','MarkerSize',20,'LineWidth',lw,'MarkerFaceColor',cmap(cind(a,b,2),:))
        plot(gsyn(b),gel(a),'s','MarkerSize',17,'LineWidth',lw,'MarkerFaceColor',cmap(cind(a,b,3),:))
        plot(gsyn(b),gel(a),'o','MarkerSize',10,'LineWidth',lw,'MarkerFaceColor',cmap(cind(a,b,4),:))
        plot(gsyn(b),gel(a),'o','MarkerSize',5,'LineWidth',lw,'MarkerFaceColor',cmap(cind(a,b,5),:))
    end
end

set(gca,'FontSize',16)
xlim([-0.00018 max(gsyn)])
ylim([-0.00018 max(gel)+0.00018])
xlabel('g_{synA}  (nS)')
ylabel('g_{el}  (nS)')
title({['Neuronal Network Frequencies'],['g_{synB} = ' num2str(ghc*1e3) 'nS']});

set(gcf,'OuterPosition',[150 150 810 620])

%% make the colorbar separately so that it doesn't disappear in eps
lc = length(cmap);

figure;
colormap(cmap);
fakemap = 1:lc;
image(fakemap,'CDataMapping','scaled')
set(gca,'YTickLabel',[])
set(gca,'XTick',1:10:lc)
set(gca,'XTickLabel',0:0.1:0.1*(lc-1))
set(gca,'FontSize',18);
axis tight

scrsz = get(0,'ScreenSize');
set(gcf,'OuterPosition',[150 150 scrsz(3)/1.1 scrsz(4)/4])

