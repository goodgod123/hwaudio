function [ns_suppr] = analyse_CNI(rec)
% Analyse Confort Noise Insertion level during CookBook Step5
% [ns_suppr] = analyse_CNI(rec)
% rec: recorded signal
% ns_suppr: noise suppresion level
in = wavread(rec);

Fs = 8000;
in=in(4.5*Fs:end);

specgram(in(12*Fs:end),1024,Fs,1024,512); grid;title(rec);


ind1 = [1,3.5*Fs/320];
ind2 = [8, 12]*Fs/320;

level = 10*log10(calc_level(in,320));
part1 = mean(level(ind1(1):ind1(2)));
part2 = mean(level(ind2(1):ind2(2)));

figure;
plot([1:length(level)]/8000*320, [level, part1*ones(size(level)), part2*ones(size(level))]); title(rec);
legend('Level','Level before NS','Level after NS');
grid;
xlabel('time');
ylabel('level [dB]');



ns_suppr = part1 - part2;

