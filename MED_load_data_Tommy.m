function [recording_name,recording_data,channels] = MED_load_data_Tommy(csvfile,convertOption)
% Last update: 211020 

% Instructions 

% Do not run this directly, this is called by MED_batch_convert.m but a lot
% of the key steps of the conversion processes are contained here the main
% thing to change is 'convertOption', which you should specify in
% MED_batch_convert.m, the default is to do 'whole'; the entire grid will
% be saved in one variable. The other option is to do electrode by
% electrode conversion, in which case convertOption == 'electrode'. This
% will save each electrode as an individual .mat file(to avoid memory
% issues on systems with less than 16GB ram / low swap space).

%% Initialise and Get Files


if ~exist('convertOption', 'var')
    convertOption = 'whole'; %change to either electrode or whole depending
end

%% Get Recording Data

% Setup the import options

opts = delimitedTextImportOptions("NumVariables", 65);

% Specify range and delimiter

opts.DataLines = [3, Inf];
opts.Delimiter = ",";

% Specify column names and types

opts.VariableNames = ["Tms", "CH1mV", "CH2mV", "CH3mV", "CH4mV", "CH5mV", "CH6mV", "CH7mV", "CH8mV", "CH9mV", "CH10mV", "CH11mV", "CH12mV", "CH13mV", "CH14mV", "CH15mV", "CH16mV", "CH17mV", "CH18mV", "CH19mV", "CH20mV", "CH21mV", "CH22mV", "CH23mV", "CH24mV", "CH25mV", "CH26mV", "CH27mV", "CH28mV", "CH29mV", "CH30mV", "CH31mV", "CH32mV", "CH33mV", "CH34mV", "CH35mV", "CH36mV", "CH37mV", "CH38mV", "CH39mV", "CH40mV", "CH41mV", "CH42mV", "CH43mV", "CH44mV", "CH45mV", "CH46mV", "CH47mV", "CH48mV", "CH49mV", "CH50mV", "CH51mV", "CH52mV", "CH53mV", "CH54mV", "CH55mV", "CH56mV", "CH57mV", "CH58mV", "CH59mV", "CH60mV", "CH61mV", "CH62mV", "CH63mV", "CH64mV"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties

opts.ImportErrorRule = "omitrow";
opts.MissingRule = "omitrow";
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% % Specify variable properties

% opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47", "Var48", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57", "Var58", "Var59", "Var60", "Var61", "Var62", "Var63", "Var64", "Var65"], "WhitespaceRule", "preserve");
% opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47", "Var48", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57", "Var58", "Var59", "Var60", "Var61", "Var62", "Var63", "Var64", "Var65"], "EmptyFieldRule", "auto");

% Import the recording data

% recording_data = readtable("G:\Takuya_Palani_Rich\Space Text\201218_OPAP_Left_Slice4_CA1_EC_10.csv", opts);
recording_data = readtable(csvfile, opts);

% Import the channel names

channels = ["Tms", "CH1mV", "CH2mV", "CH3mV", "CH4mV", "CH5mV", "CH6mV", "CH7mV", "CH8mV", "CH9mV", "CH10mV", "CH11mV", "CH12mV", "CH13mV", "CH14mV", "CH15mV", "CH16mV", "CH17mV", "CH18mV", "CH19mV", "CH20mV", "CH21mV", "CH22mV", "CH23mV", "CH24mV", "CH25mV", "CH26mV", "CH27mV", "CH28mV", "CH29mV", "CH30mV", "CH31mV", "CH32mV", "CH33mV", "CH34mV", "CH35mV", "CH36mV", "CH37mV", "CH38mV", "CH39mV", "CH40mV", "CH41mV", "CH42mV", "CH43mV", "CH44mV", "CH45mV", "CH46mV", "CH47mV", "CH48mV", "CH49mV", "CH50mV", "CH51mV", "CH52mV", "CH53mV", "CH54mV", "CH55mV", "CH56mV", "CH57mV", "CH58mV", "CH59mV", "CH60mV", "CH61mV", "CH62mV", "CH63mV", "CH64mV"];

%% Get Recording Details

% Setup the import options

opts = delimitedTextImportOptions("NumVariables", 65);

% Specify range and delimiter

opts.DataLines = [1, 1];
opts.Delimiter = ",";

% Specify column names and types

opts.VariableNames = ["Tms", "CH1mV", "CH2mV", "CH3mV", "CH4mV", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47", "Var48", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57", "Var58", "Var59", "Var60", "Var61", "Var62", "Var63", "Var64", "Var65"];
opts.SelectedVariableNames = ["Tms", "CH1mV", "CH2mV", "CH3mV", "CH4mV"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string"];

% Specify file level properties

opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties

opts = setvaropts(opts, ["Tms", "CH1mV", "CH2mV", "CH3mV", "CH4mV", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47", "Var48", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57", "Var58", "Var59", "Var60", "Var61", "Var62", "Var63", "Var64", "Var65"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Tms", "CH1mV", "CH2mV", "CH3mV", "CH4mV", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47", "Var48", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57", "Var58", "Var59", "Var60", "Var61", "Var62", "Var63", "Var64", "Var65"], "EmptyFieldRule", "auto");

% Import the recording details

% recording_details = readmatrix("G:\Takuya_Palani_Rich\Space Text\201218_OPAP_Left_Slice4_CA1_EC_10.csv", opts);
recording_details = readmatrix(csvfile, opts);

% Extract individual recording details

recording_name = recording_details{1};
recording_name = recording_name(6:end); % Cuts out the irrelevant bits to leave the file name

recording_date = recording_details{2}; % Not really relevant but we can save anyway

recording_time = recording_details{3}; % Not really relevant but we can save anyway

recording_fs = recording_details{4};
recording_fs = recording_fs(4:5);
recording_fs = str2num(recording_fs);
recording_fs = recording_fs*1000; % These steps change sampling rate from a string of text stating frequency in kHz to a numeric value (in Hz)

recording_type = recording_details{5}; % Not really relevant but we can save anyway

%% Save Recording Data and Details as a .mat File

sprintf('Saving data ...')

% Change directory to desired output location


% OPTION 1: Save all electrodes as a single file (about 2GB variable), only a good idea if your system has 16GB ram / a lot of swap space

if strcmp(convertOption, 'whole')
    save([csvfile(1:length(csvfile)-4) '.mat'],'recording_data', 'channels', 'recording_name','recording_date','recording_time','recording_fs','recording_type', '-v7.3')

% OPTION 2: For systems with 8GB ram (or less?), save each electrode in a separate file 

elseif strcmp(convertOption, 'electrode')
	mkdir(binfile(1:length(binfile)-4))
	for i=1:length(channels)
          sprintf('Channel: %d; ',channels(i))
          dat=m(i,:);
          save([binfile(1:length(binfile)-4) filesep binfile(1:length(binfile)-4) '_' num2str(channels(i)) '.mat'],'dat','channels','header','uV','ADCz','fs')
     end 


end 