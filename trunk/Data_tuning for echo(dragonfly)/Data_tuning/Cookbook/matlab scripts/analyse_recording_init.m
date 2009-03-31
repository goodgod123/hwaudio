function [dt_suppr, fe_suppr, glitches]=analyse_recording_init(ref, rec)


refin = wavread(ref);
in = wavread(rec);

Fs = 8000;
FEonly = [1/Fs,40]*Fs;
DTseq = [40.5, 55]*Fs;


dt = in(DTseq(1):DTseq(2));
dtref = refin(45.5*Fs:60*Fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DT                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xc = xcorr(dtref(1:3*Fs), dt(1:3*Fs));
[m,i] = max(xc);
offset = 3*Fs - i;
if(offset > 0)
    dtref = dtref(1:end-offset);
    dt = dt(offset+1:end);
else
    dtref = dtref(1-offset:end);
    dt = dt(1:end+offset);
end;
    
dtref_level = calc_level(dtref,80);
dtref_mean  = mean(dtref_level);
dtref_min  = min(dtref_level);
dtref_th = (dtref_mean + dtref_min)/2;
dtref_IND = find(dtref_level>dtref_th);
dt_level = calc_level(dt,80);
dt_suppr = 10*log10(var(dt)/var(dtref));

% figures to analyse
figure; 
subplot(2,1,1); H = plot([1:length(dtref)]/Fs, [dtref, dt]); 
set(H(1), 'Color', [0 .6 0]);
set(H(2), 'Color', [1 0 0]);
grid; axis tight;
subplot(2,1,2); 
H = plot(  [1:length(dt_level)]/Fs*80, [  10*log10(dt_level./dtref_level), dt_suppr*ones(size(dt_level))] );grid; axis tight;
set(H(1), 'Color', [0 .6 0]);
set(H(2), 'Color', [1 0 0]);
fn = 'dt_analysis'; print( gcf, '-dtiffnocompression', fn );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECHO                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(offset > 0)
    fe = in(FEonly(1)-offset:FEonly(2)-offset-1);
    feref = refin(5*Fs:45*Fs);
else
   fe = in(FEonly(1):FEonly(2));
   feref = refin(5*Fs+offset:45*Fs+offset-1);
end;



feref_level = calc_level(feref,80);
feref_mean  = mean(feref_level);
feref_min  = min(feref_level);
feref_th = (feref_mean + feref_min)/2;
feref_IND = find(feref_level>feref_th);
fe_level = calc_level(fe,80);
fe_suppr = 10*log10(mean(fe_level(feref_IND))/mean(feref_level(feref_IND)) );  

%figures to analyse
figure
subplot(3,1,1); 
H = plot([1:length(fe)]/8000, [feref fe]); 
set(H(1), 'Color', [0 .6 0]);
set(H(2), 'Color', [1 0 0]);
xlabel('Time');
ylabel('Amplitude');
grid;axis tight; 
subplot(3,1,2); 
H = plot([1:length(fe_level)]/8000*80, 10*log10(fe_level)); grid; axis tight; 
set(H(1), 'Color', [0 .6 0]);
xlabel('Time');
ylabel('Level (dB)');
subplot(3,1,3);  specgram(fe,1024,8000,1024,512); 
fn = 'echo_analysis'; print( gcf, '-dtiffnocompression', fn );

glitches = FEonly(1)/Fs+detect_glitch(fe,4);