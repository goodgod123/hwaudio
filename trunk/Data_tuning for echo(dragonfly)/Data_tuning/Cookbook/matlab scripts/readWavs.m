function [ref, sweep] = readWavs(range, Letter, IND)


name = ['ref.wav' ];
in = wavread(name);
ref = in(IND);
sweep = zeros(length(IND),length(range));

for i = 1:length(range)
    name = [Letter, num2str(range(i)), '.wav' ];
    in = wavread(name);
    sweep(:,i)=in(IND);
end;