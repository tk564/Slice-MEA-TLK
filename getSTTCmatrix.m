function STCCmatrix = getSTTCmatrix(newL, morph, dtv, Time, logit, STCCmatrix)
for i = 1:newL

    N1v = nnz(morph(:,i));
    spike_times_1 = find(morph(:,i));

    for j = 1:newL
        N2v = nnz(morph(:,j));
        spike_times_2 = find(morph(:,j));

       tileCoef = sttc(N1v, N2v, dtv, Time, spike_times_1, spike_times_2);
        if isnan(tileCoef)
            tileCoef = 0;
        end
if logit == 1
        tileCoef = log(tileCoef);
end
       STCCmatrix(i,j) = tileCoef;
  
    end
end
end