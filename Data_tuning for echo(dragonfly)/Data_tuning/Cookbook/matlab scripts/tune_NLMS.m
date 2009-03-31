function [suppr] = tune_NLMS(Nrange)
% Analyse and research optimal number of taps of the NLMS FIR filter
% so as to acheive best Echo Cancellation perfomance during CookBook Step2
% [suppr] = tune_NLMS(Nrange)
% Nrange: range of taps of the recordings relative [min:step:max]
% e.g [32:16:96] or [32,48,64,80,96]
% suppr: Echo Suppression Level
start = 4;
dur = 8;
p=2;
stop = 28;
Fs = 8000;


nrlevels = 4;
suppr = zeros(length(Nrange),nrlevels);


for i = 1 : length(Nrange)
    for j = 1 : nrlevels

        IND = [start*8000 + (j-1)*(dur+p)*8000 : start*8000 + j*dur*8000 + (j-1)*p*8000]; 
        [ref, N] = readWavs(Nrange, 'N', IND);
        reflevel = calc_level(ref,40);
        mref = mean(reflevel);
        minref = min(reflevel);
        thref = (mref+minref)/2;
        INDref = find(reflevel>thref);
        mref = 10*log10(mean(reflevel(INDref)));
        
        level = calc_level(N(:,i),40);
        m = mean(level);
        mini = min(level);
        thi = (m+mini)/2;
        INDi = find(level>thi);
        mi = 10*log10(mean(level(INDref)));    
        suppr(i,j) = mref - mi;
    
    end;
end;

plot(Nrange,suppr);
grid
ylabel('Echosuppression (dB)');
xlabel('Filterlength');

string = [];
for i = 1:nrlevels
    string =[string ; 'level ', num2str(i) ] ;
end;
legend(string,4)