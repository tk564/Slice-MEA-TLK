function [value] = findRuns(input, runlength)

runlength = runlength-1;
output = zeros(1,length(input));
for i = 1:length(input)-runlength
    if input(i) == input(i+runlength)-runlength
        output(i) = 1;
    end
end
 if nnz(output) > 0
                value = find(output == 1, 1, 'first');
                else
                % if a sufficiently long run is not found just outputs the
                % largest value
                value = length(input);
 end


