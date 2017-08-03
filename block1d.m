function y = block1d(x, nwind, ws)
x = x(:);

nx = length(x);
ncol = (nx-(nwind - ws))/ws;
y=zeros(nwind, ncol);

colindex = 1 + (0:ncol-1)*ws;
rowindex = transpose(1:nwind);
y(:) = x(rowindex(:, ones(1, ncol)) + colindex(ones(nwind,1),:) -1);
