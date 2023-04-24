clc;
clear;

variables = ["x1","x2","a1","a2","s2","s3","sol"];

M = 10000;
cost = [-2 -1 -M -M 0 0 0];
a = [
    3 1 1 0 0 0;
    4 3 0 1 -1 0;
    1 2 0 0 0 1;
];

num_constraints = size(a, 1);

b = [3;6;3];

a = [a b];

bv = zeros(1, size(a,1));
s = eye(num_constraints);

for i=1:size(s,2)
    for j=1:size(a,2)
        if a(:,j) == s(:,i)
            bv(i) = j;
        end
    end
end


fprintf("Basic variables: \n");
disp(variables(bv));

run = true;
while run
    zjcj = cost(bv)*a - cost;
    
    zcj = [zjcj; a];
    table = array2table(zcj);
    table.Properties.VariableNames = variables;
    disp(table);
    
    if any(zjcj < 0)
        fprintf("The bfs is not optimal\n");
        [entercol, pvt_col] = min(zjcj);
    
        sol = a(:, end);
        pivot = a(:, pvt_col);
    
        ratio = zeros(1, num_constraints);
    
        for i=1:num_constraints
            if pivot(i) > 0
                ratio(i) = pivot(i)/sol(i);
            else
                ratio(i) = inf;
            end
        end
    
        [leavingval, pvt_row] = min(ratio);

        bv(pvt_row) = pvt_col;

        fprintf("New basic variables: \n");
        disp(variables(bv));
    
        key = a(pvt_row, pvt_col);
        a(:, pvt_col) = a(:, pvt_col)/key;
    
        for i=1:num_constraints
            if i~=pvt_row
                a(i,:) = a(i,:) - a(i, pvt_col)*a(pvt_row,:);
            end
        end
    
        zjcj = zjcj - zjcj(pvt_col)*a(pvt_row,:);
    else
        run = false;
        fprintf("Optimal Solution reached:\n");
        zcj = [zjcj; a];
        table = array2table(zcj);
        table.Properties.VariableNames = variables;
        disp(table);
        fprintf("New basic variables: \n");
        disp(variables(bv));
    end

end