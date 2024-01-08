
C = 5; % active regions
f = 0.4; % frequency in HZ
f = f/1000;
L = 18*60*1000; % length of recording
modelMatrix = zeros(L,C);
N = L*f; % number of spikes



for i = 1:C
    for j = 1:N
         x = round(rand*L);
         modelMatrix(x,i) = 1;
         if x > L-201
         modelMatrix(x+1:x+200,i) = 0;
         end
    end
end


spikes = modelMatrix;



%
adjacencyMatrix = zeros(size(spikes,2), size(spikes,2));

for i = 1:size(spikes,2)

    for j = 1:size(spikes,1)

        if spikes(j,i) == 1 % if a spike occurs in this region

            for k = 1:size(spikes,2) % goes through all regions

                if nnz(spikes(j+t1:j+t2,k)) > 0 % concurrency window of 1-10ms, ask Rich but 10ms previously recommended by Tanja as used in STDP experiments

                    adjacencyMatrix(i,k) = adjacencyMatrix(i,k)+1; % adds 1 to the weight for region i communicating to region k
                   
                end
            end
        end
    end
end
adjacencyMatrix


