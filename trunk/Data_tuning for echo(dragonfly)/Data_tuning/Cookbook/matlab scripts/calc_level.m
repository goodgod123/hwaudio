function [level] = calc_level(in, frame)

tmp = [in; zeros( frame - mod(length(in),frame) ,size(in,2))];
%tmp=in;

buffer = reshape(tmp, frame, length(tmp)/frame)';
level = zeros(length(buffer), 1);

level(1) = buffer(1,:)*buffer(1,:)';

alpha = 0.95;

for i = 2:length(level)
    level(i) = (1-alpha)*level(i-1) + alpha/frame* buffer(i,:)*buffer(i,:)';
end;


