function [] = structToJSON(allData,targetString)
%STRUCTTOJSON Converting struct to .json file with JSON encoding
%   Using this function to convert a struct, which is created after 
%   reading off and systematising a TDMS file from LabView. 

jsontext=jsonencode(allData); %encoding a struct to json text
fid = fopen(targetString,'w');
fprintf(fid,'%s',jsontext);
fclose(fid);

end