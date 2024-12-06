function [allData] = tdmsToStruct(tdmsFileName)
%RAWLABVIEWDATA Summary of this function goes here
%   Detailed explanation goes here

%Make sure we have the right time zone in order to accommodate for that in
%the timestamps of the data
timezone = datetime('now','TimeZone','local','Format','Z');
offsetUTC = int2str(hours(tzoffset(timezone)));

%Need to read of the tdms file that the data was saved to in MATLAB. 
params = {'UTC_DIFF',offsetUTC,'DATE_STR_FORMAT','yyyy-mm-dd HH:MM:SS.FFF AM'};
my_tdms_struct=TDMS_getStruct(tdmsFileName,[],params);

%Get the timestamps for data acquisition triggers and remove the
%duplicating timestamps
triggerTime=datestr(my_tdms_struct.Trigger_Date.Untitled.data,'yyyy-mm-dd HH:MM:SS');
triggerTimeUnique=unique(triggerTime,'rows','stable');

%Get the increments between data points (in time) and calculate the
%sampling frequency
incrementTime=my_tdms_struct.Incremental_time.Untitled.data(1);
samplingFreq=1/incrementTime;

%Create additional timestamps in between the trigger timestamps in order to
%have the timestamps of every recorded data point
triggerDatestamp=datetime(triggerTimeUnique,'InputFormat','yyyy-MM-dd HH:mm:ss','Format', 'yyyy-MM-dd HH:mm:ss.SSS');
diff=seconds(triggerDatestamp(2)-triggerDatestamp(1));
factor=round(diff/incrementTime,0);
addedSeconds=(0:(factor-1))*incrementTime;
lengthInitial=length(triggerDatestamp);
lengthIteration=length(addedSeconds);
datapointsDatestamp=repmat(triggerDatestamp(1),lengthInitial*lengthIteration,1);

for i=1:lengthInitial
    datapointsAdd=(triggerDatestamp(i)+seconds(addedSeconds)).';
    startIndex=(i-1)*lengthIteration+1;
    lastIndex=i*lengthIteration;
    datapointsDatestamp(startIndex:lastIndex)=datapointsAdd;
end

%Getting purely time (starting with zero) from the datetime values
datapointsTime=seconds(datapointsDatestamp-datapointsDatestamp(1));

%Getting all analog data and finding out the number of points
allAnalog=my_tdms_struct.Analog_Data;
fieldsAnalog=fieldnames(allAnalog);
firstAColumn=fieldsAnalog(3);
firstAColumn=firstAColumn{1,1};
firstAColumn=allAnalog.(firstAColumn).data;
lengthAnalog=length(firstAColumn);
numberPD=numel(fieldsAnalog)-2;

%Getting all digital data and finding out the number of points
allDigital=my_tdms_struct.Digital_Data;
fieldsDigital=fieldnames(allDigital);
firstDColumn=fieldsDigital(3);
firstDColumn=firstDColumn{1,1};
firstDColumn=allDigital.(firstDColumn).data;
lengthDigital=length(firstDColumn);
numberLED=numel(fieldsDigital)-2;

%Determining the number of data points for date, analog data and digital
%data and picking the smallest number for the future
lengthTime=size(datapointsDatestamp,1);
lengthData=min([lengthTime lengthAnalog lengthDigital]);

%Creating a structure array where I am going to store all of the data
allData = struct;
allData.Sampling_Frequency=samplingFreq;
allData.Date = datapointsDatestamp(1:lengthData,:);
allData.Time=datapointsTime(1:lengthData);
allData.PD_no=numberPD;
allData.LED_no=numberLED;

%Assigning the data of all analog inputs to corresponding PDs
for i=1:numberPD
   pdName=append('PD',int2str(i));
   pdColumn=fieldsAnalog(i+2);
   pdColumn=pdColumn{1,1};
   pdData=(allAnalog.(pdColumn).data).';
   allData.(pdName)=pdData(1:lengthData);
end

%Assigning the data of all digital inputs to corresponding LEDs
for i=1:numberLED
   ledName=append('LED',int2str(i));
   ledColumn=fieldsDigital(i+2);
   ledColumn=ledColumn{1,1};
   ledData=(allDigital.(ledColumn).data).';
   allData.(ledName)=ledData(1:lengthData);
end

end

