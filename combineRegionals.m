function spikes = combineRegionals(fileName, maxMatrix, CA1layers)

file.name = fileName;
[slicepics, row] = rowForSlicepics(file);


DG = str2num(slicepics{row,5});
CA1 = str2num(slicepics{row,7});
CA1oriens = str2num(slicepics{row,8});
CA1pyramidale = str2num(slicepics{row,9});
CA1radiatum = str2num(slicepics{row,10});
CA1moleculare = str2num(slicepics{row,11});
CA3 = str2num(slicepics{row,6});
EC = str2num(slicepics{row,12});





%% load combined spikes for all



if CA1layers == 1
    spikes = zeros(size(maxMatrix,1),7); % sets up a matrix to accomodate a 25 min recording
    try
        spikes(:,1) = sum(maxMatrix(:,DG),2);
    catch
        spikes(:,1) = 0;
    end
    try 
        spikes(:,2) = sum(maxMatrix(:,CA1oriens),2);
    catch
        spikes(:,2) = 0;
    end
    try 
        spikes(:,3) = sum(maxMatrix(:,CA1pyramidale),2);
    catch
        spikes(:,3) = 0;
    end
    try
        spikes(:,4) = sum(maxMatrix(:,CA1radiatum),2);
    catch
        spikes(:,4) = 0;
    end
    try
        spikes(:,5) = sum(maxMatrix(:,CA1moleculare),2);
    catch
        spikes(:,5) = 0;
    end
    try 
        spikes(:,6) = sum(maxMatrix(:,CA3),2);
    catch
        spikes(:,6) = 0;
    end
    try 
        spikes(:,7) = sum(maxMatrix(:,EC),2);
    catch
        spikes(:,7) = 0;
    end
else
    spikes = zeros(size(maxMatrix,1),4);


 try
        spikes(:,1) = sum(maxMatrix(:,DG),2);
    catch
        spikes(:,1) = 0;
 end
 try
     spikes(:,2) = sum(maxMatrix(:,CA1),2);
 catch
     spikes(:,2) = 0;
 end
  try 
        spikes(:,3) = sum(maxMatrix(:,CA3),2);
    catch
        spikes(:,3) = 0;
    end
    try 
        spikes(:,4) = sum(maxMatrix(:,EC),2);
    catch
        spikes(:,4) = 0;
    end
end

spikes = sparse(spikes);


end