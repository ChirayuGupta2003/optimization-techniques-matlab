clear;

cost = [-7.5 3 0 0 0 -1 -1 0];
ocost = cost;
variables = ["x1","x2","x3","s1","s2","a1","a2","sol"];
ovariables = ["x1","x2","x3","s1","s2","sol"];
a = [
    3 -1 -1 -1 0 1 0;
    1 -1 1 0 -1 0 1
];


num_variables = 3;

b = [3;2];

a = [a b];
bv = [6 7];

%% Phase 1


costph1 = [0 0 0 0 0 -1 -1 0];
startbv = find(costph1<0);


zjcj = costph1(bv)*a - costph1;
zcj = [zjcj; a];
table = array2table(zcj);
table.Properties.VariableNames = variables;

fprintf("Initial table:\n");

disp(table);

fprintf("**********************************\n");
fprintf("           PHASE 1 START\n");
fprintf("**********************************\n");


[BFS, a] = simp(a, bv, costph1, variables);

%% Phase 2

fprintf("**********************************\n");
fprintf("           PHASE 2 START\n");
fprintf("**********************************\n");


a(:,startbv) = [];
cost(startbv) = [];
[optbfs, opta] = simp(a, BFS, cost,ovariables);

final_bfs = zeros(1, size(variables,2));
final_bfs(optbfs) = opta(:, end);
final_bfs(end) = sum(final_bfs.*ocost);

final_bfs_table = array2table(final_bfs);
final_bfs_table.Properties.VariableNames = variables;
fprintf("The final bfs is:\n");
disp(final_bfs_table);



%% simplex function
function [BFS,a] = simp(a,bv,cost,variables)
    zjcj = cost(bv)*a - cost;
    run = true;
    num_constraints = size(a,1);
    while run
        zc = zjcj(1:end-1);
        
        if any(zc<0)
            fprintf("The bfs is not optimal\n");
            
            [entercol, pvt_col] = min(zc);
            
            ratio = [];
            pivot = a(:, pvt_col);
            sol = a(:, end);
            
            for i=1:num_constraints
                if pivot(i) > 0
                    ratio(i) = sol(i)/pivot(i);
                else
                    ratio(i) = inf;
                end
            end
            
            
            [leaving, pvt_row] = min(ratio);
            
            bv(pvt_row) = pvt_col;
        
            fprintf("New bv:\n");
            disp(variables(bv));
        
            key = a(pvt_row, pvt_col);
            a(pvt_row, :) = a(pvt_row, :)./key;
        
            for i=1:num_constraints
                if i~=pvt_row
                    a(i,:) = a(i,:) - a(i,pvt_col)*a(pvt_row,:);
                end
            end
        
            zjcj = zjcj - zjcj(pvt_col)*a(pvt_row,:);
        
            
        else
            fprintf("Optimal Solution is reached\n");
            run = false;
        end
        zcj = [zjcj; a];
        table = array2table(zcj);
        table.Properties.VariableNames = variables;
        disp(table);
        fprintf("Basic variables\n");
        disp(variables(bv));
    end
    BFS = bv;
end


