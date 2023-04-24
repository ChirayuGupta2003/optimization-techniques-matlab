clear;


variables = ["x1", "x2", "s1", "s2", "sol"];
cost = [-5 -6 0 0 0];
a = [-1 -1; -4 -1];
b = [-2;-4];
num_variables = size(a, 2);
num_constraints = size(a, 1);

s = eye(num_constraints);

a = [a s b];
bv = num_variables+1:size(a,2)-1;

fprintf("Basic variables: \n");
disp(variables(bv));

zjcj = cost(bv)*a-cost;

zc = [zjcj; a];
table = array2table(zc);
table.Properties.VariableNames = variables;
disp(table);

run = true;

while run
    
    sol = a(:, end);
    
    if any(sol < 0)
        fprintf("The current bfs is not feasible \n");
    
        [leavingrow, pvt_row] = min(sol);
        
        ratio = [];
        pivot = a(pvt_row, :);
        zj = zjcj(:,1:end-1);
    
        for i=1:size(a,2)-1
            if pivot(i)<0
                ratio(i) = abs(zj(i)/pivot(i));
            else
                ratio(i) = inf;
            end
        end
    
        [minval, pvt_col] = min(ratio);
        
        bv(pvt_row) = pvt_col;
        fprintf("Basic variables: \n");
        disp(variables(bv));
    
        key = a(pvt_row,pvt_col);
    
        a(pvt_row,:) = a(pvt_row,:)./key;
        
        for i=1:size(a,1)
            if i~=pvt_row
                a(i,:) = a(i,:) - a(pvt_row,:).*a(i,pvt_col);
            end
        end
    
        zjcj = zjcj - zjcj(pvt_col).*a(pvt_row,:);
    
       
    else
        run = false;
        fprintf("Feasible solution reached\n");
    end
    
    zc = [zjcj; a];
    table = array2table(zc);
    table.Properties.VariableNames = variables;
    disp(table);
end




