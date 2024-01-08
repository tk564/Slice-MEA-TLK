
%% combine files
% set each of these to the two files which need concatenation
% will have to do manually can't think of an automatic way

clear, close all

cd 'E:/Slice_MEA'

% file1 = '20171123014.mat'; % make this the first one chronologically
% file2 = '20171123015.mat'; % then this one
% recording_name = '20171123014-15'; % and this for the output

% what happened to 1005?

todo = {'20230225010', '20230225011', '20230225010-11'};

for i = 1:size(todo,1)

file1 = char(todo(i,1));
file2 = char(todo(i,2));
recording_name = char(todo(i,3))

x = load(file1);
y = load(file2);

channels = x.channels;
recording_date = x.recording_date;
recording_fs = x.recording_fs;
recording_time = x.recording_time;
recording_type = x.recording_type;

x = x.recording_data;
y = y.recording_data;

recording_data = [x ; y];

fileName = strcat(recording_name, '.mat'); 
save(fileName, 'channels', 'recording_data', 'recording_date', 'recording_fs', 'recording_name', 'recording_time', 'recording_type', '-v7.3');

clearvars recording_data x y

end

