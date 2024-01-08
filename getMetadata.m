function [line, condition, age, slice, side] = getMetadata(recording, allData)
% looks in AD and Epilepsy to extract relevant metadata for the output file
%% load the xlsc


allData = table2cell(allData); % convert to cell array so can search in


year = {recording(1:4)}; % extract relevant parts of name to form date to search
month = {recording(5:6)};
day = {recording(7:8)};
id = {recording(9:length(recording))};

searchID = strcat(year, '.', month, '.', day, {' '}, id); % concatenate into an ID to search for

[r, c] = find(strncmp(allData, [searchID], 14)); % find location of the searchID in cell array
location = [r c];

if ~isempty(location)
    if size(location,1) > 1
        line = 'mistake in table - date used twice, determine manually';
        condition = NaN;
        age = NaN;
        slice = NaN;
        side = NaN;
    else
    %% get side
        sideCell = allData(r, c+1); % get cell with side in from next column over
    
        sideCell = split(sideCell, '.'); % splits into regions separated by .
        side = sideCell(size(sideCell,1),1); % takes the last chunk to be the side, L R or NO
        % potentially convert into 1 for L, 2 for R, and 0 for no side as might be
    
    % easier to handle
    
    %% get age
    
    age = allData(r, c+2); % gets age from cell
    age = cell2mat(age); % converts to number
    
    %% get slice number
    
    slice = allData(r, c+3); % gets slice number from cell
    slice = cell2mat(slice); % converts to number
    
    %% condition and line
    
    inforow = find(strcmp(allData(1:r,c), ['File name']), 1, 'last'); % finds the bottom row of the header information for the table
    
    condition = allData(inforow-1,c);
    
    lineCell = allData(inforow-1,c+1);
    lineCell = split(lineCell);
    line = strcat(lineCell(size(lineCell,1)-1,1), lineCell(size(lineCell,1),1));
    line = num2cell(char(line));
    line = strcat(line(length(line)-1), line(length(line))); % turns into a unique 2 character reference

    
    end
else
   disp('could not find recording in spreadsheet') 
   line = 'could not find recording in spreadsheet';
        condition = NaN;
        age = NaN;
        slice = NaN;
        side = NaN;
end



