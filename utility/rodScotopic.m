%% Plot scotopic sensitivity


%%
wave = 400:10:650;
rods = vcReadSpectra('rods',wave);

vcNewGraphWin;
p = plot(wave,rods,'o');
set(p,'markerSize',10)
set(gca,'xtick',[400:50:600])
set(gca,'ytick',[0:.25:1])

xlabel('Wavelength (nm)')
ylabel('Scotopic sensitivity')
grid on


%%