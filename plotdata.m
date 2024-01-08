function plotdata(dep)
%% select what to plot

folder = ('G:/Slice_MEA');
 

dependent = dep;



%% load outputs
cd(folder)
cd .\OutputData

d= dir('*mat');
 dd = zeros(length(d),1);
 for j = 1:length(d)
  dd(j) =d(j).datenum;
 end
 [tmp i] = max(dd);
 file = load(d(i).name);
 output = file.output;

 cd(folder)
    
 pharmacology = {'K+', 'gabazine'};

%%
    plotAgainstConc(dependent, output);
    
 % plotAgainstGabazine(dependent, output);





