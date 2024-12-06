function [] = tdmsToJSON(filename)
%TDMSTOJSON Converting TDMS to .txt file with JSON encoding
%   This function takes the raw output file from the DAQ card in B.13 
%   laboratory and creates a .json file with all voltages and time values
%   encoded in JSON format, so that it can be further used in Python. 

[allData]=tdmsToStruct(filename); %getting the struct from tdms
newFilename=strrep(filename,'.tdms','.json'); %constructing a new filename
structToJSON(allData,newFilename);

end

