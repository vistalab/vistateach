wave = 400:700;
XYZ = vcReadSpectra('XYZ',wave);

vcNewGraphWin;
plot(wave,XYZ(:,1),'r-',wave,XYZ(:,2),'g-',wave,XYZ(:,3),'b-');
grid on;
xlabel('Wavelength (nm)')
legend({'x-bar','y-bar','z-bar'})
