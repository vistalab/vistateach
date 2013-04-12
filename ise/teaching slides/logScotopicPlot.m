% Log plot of the scotopic spectral sensitivity curve
%
fullName = vcSelectDataFile([]);
wave = 400:1:700;
data = vcReadSpectra(fullName,wave);

semilogy(wave,data); grid off

