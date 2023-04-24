cost = [2 7 4;3 3 1;
        5 5 4;1 6 2];

a = [5 8 1 14];
b = [7 9 18];

if sum(a) == sum(b)
    fprintf("Given problem is balanced\n");
else
    fprintf("Given problem is unbalanced\n");
    if sum(a) < sum(b)
        cost = [cost; zeros(1,size(b,2))];
        a(end+1) = sum(b)-sum(a);
    else
        cost = [cost zeros(size(a,1),1)];
        b(end+1) = sum(a)-sum(b);
    end
end




icost = cost;
x = zeros(size(cost));
[m, n] = size(cost);
bfs = m+n-1;

for i=1:size(cost, 1)
    for j=1:size(cost,2)
        hh = min(cost(:));
        [rowind, colind] = find(hh==cost);
        x11 = min(a(rowind), b(colind));
        [val, ind] = max(x11);
        ii = rowind(ind);
        jj = colind(ind);
        y11 = min(a(ii), b(jj));
        x(ii, jj) = y11;
        a(ii) = a(ii) - y11;
        b(jj) = b(jj) - y11;
        cost(ii, jj) = inf;
    end
end

fprintf("Initial BFS \n");
ib = array2table(x);
disp(ib);

totalbfs = length(nonzeros(x));
if totalbfs == bfs
    fprintf("The initial bfs is non-degenerate\n");
else
    fprintf("The initial bfs in degenerate\n");
end

initialcost = sum(sum(icost.*x));
fprintf("Initial cost:\n");
disp(initialcost);