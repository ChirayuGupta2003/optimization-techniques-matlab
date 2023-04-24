format short
clear all
clc

num_variables = 3;
C = [-1 3 -2];
A = [3 -1 2; -2 4 0; -4 3 8];
b = [7; 12; 10];
num_constraints = size(A,1);
s = eye(num_constraints);

A = [A s b];

cost = [C zeros(1, num_constraints + 1)];

bv = (num_variables+1:size(A, 2)-1);

zjcj = cost(bv) * A - cost;

zcj = [zjcj; A];

table = array2table(zcj);
table.Properties.VariableNames(1:size(zcj,2)) = {'x1', 'x2', 'x3', 's1', 's2', 's3', 'sol'};

run = true;

while run
if any(zjcj < 0)
    disp("Not Optimal");
    disp("================== NEXT ITERATION ==================");
    disp("OLD Basic Variable (BV)=");
    disp(bv);

    %% Finding the entring variable

    zc = zjcj(1:end-1); % zjcj but not including the sol
    [entercol, pvt_col] = min(zc);

    fprintf("The most positive element in zj-cj row is %d corresponding to column %d\n", entercol, pvt_col);
    

    %% Finding the leaving variable

    sol = A(:, end);
    pivot = A(:, pvt_col);

    ratio = zeros(1, num_constraints);

    if all(pivot <= 0)
        error("LPP is unbounded");
    else
        for i=1:size(pivot, 1)
            if pivot(i) > 0
                ratio(i) = sol(i) ./ pivot(i);
            else
                ratio(i) = inf;
            end
        end

        %% Finding the minimum

        [minratio, pvt_row] = min(ratio);
    end

        disp("Min ratio corresponding to pivot row is %d", pvt_row);


        pivot_key = A(pvt_row, pvt_col);

        A(pvt_row,:) = A(pvt_row,:)/pivot_key;


        bv(pvt_row) = pvt_col;

        for i=1:size(A, 1)
            if i~=pvt_row
                A(i,:) = A(i,:) - A(i,pvt_col)*A(pvt_row, :);
            end
        end

        zjcj = zjcj - zjcj(pvt_col)*A(pvt_row,:);

        zcj = [zjcj; A];
        table = array2table(zcj);
        table.Properties.VariableNames(1:size(zcj, 2)) = {'x1', 'x2', 'x3', 's1', 's2', 's3', 'sol'};


        bfs = zeros(1, size(A, 2));
        bfs(bv) = A(:, end);

        bfs(end) = sum(bfs.*cost);
        curr_bfs = array2table(bfs);
        curr_bfs.Properties.VariableNames(1:size(curr_bfs, 2)) = {'x1', 'x2', 'x3', 's1', 's2', 's3', 'sol'};

        


else
    disp("Optimal Solution reached");
    disp(table);
    run = false;
end
end
