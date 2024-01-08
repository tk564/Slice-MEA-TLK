function statsChecks = checkNormAndVariance(data)
statsChecks = zeros(size(data,1),2);
%% check 
% do all the 7.5mMs first then the 10mMs

for i = 1:size(statsChecks,1)

    % check normality
    if length(nonzeros(data(i,:))) > 2
        x = nonzeros(data(i,:));
        [norm, ~, ~] = swtest(x, 0.05);
        % if H = 1 then data is normal (modified from original)
        
        statsChecks(i,1) = norm;
    else
        statsChecks(i,1) = 2;
        % ask Rich what to do here - for now just set to match the mode of
        % all of them
    end



end


[a b] = find(statsChecks(:,1) == 2);
replace = [a b];
if ~isempty(replace)
    for i = 1:size(replace,1)
        statsChecks([replace(i,:)]) = mode(statsChecks(:,1));
    end
end



%% alter the input to match function
% if H == 1 then homoscedacity was met
% do for 7.5mM recordings
modified = zeros(1,2);
for i = 1:12
    modified = [modified; nonzeros(data(i,:)) ones(length(nonzeros(data(i,:))),1)*(i)];
end
modified(1,:) = [];

H = Btest(modified, 0.05);
statsChecks(1:12,2) = H;

% do for 10mM
% modified = zeros(1,2);
% for i = 7:12
%     modified = [modified; nonzeros(data(i,:)) ones(length(nonzeros(data(i,:))),1)*(i-6)];
% end
% modified(1,:) = [];
% 
% H = Btest(modified, 0.05);
% statsChecks(7:12,2) = H;
end