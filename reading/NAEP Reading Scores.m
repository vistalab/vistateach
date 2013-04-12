% From the NAEP web-site.  California compared to US average in reading
% Fourth grade scores.  In a PDF I saved out in the readings

year = [1992, 1994, 1998, 1998.01, 2002, 2003];
caScore = [202, 197,202, 202, 206, 206];
usScore = [215,212,215,213,217,216];

plot(year, caScore,'-o',year, usScore,'r-*');
set(gca,'ylim',[190,230])
legend('California','US')

grid on
xlabel('Year')
ylabel('Reading score (4th grade)')
