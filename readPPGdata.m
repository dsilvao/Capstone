clearvars;

%% Import Data

% rawExt = 'raw.csv';
% dataloc = '/Users/AnthonyGuariglia/Desktop/';
% rawFilename = [dataloc 'output.txt'];
rawFilename = ['output.txt']; 


rawData = dlmread(rawFilename,' ',1,0);

rawData = rawData(700:end-750,:);
filteredPPG = rawData(:,1);
%DerivativePPG = diff(filteredPPG); 
rawECG = rawData(:,2);
[datPPG,idxPPG] = findpeaks(filteredPPG(:,:),'MinPeakDistance',25);
[datECG,idxECG] = findpeaks(rawECG(:,1),'MinPeakProminence',4000,'MinPeakDistance',25);
%[datDPPG,idxDPPG] = findpeaks(DerivativePPG(:,:),'MinPeakDistance',25);

h = 1;
PTTvals = zeros(size(idxPPG,1),1); 
while h < size(idxPPG,1) + 1
  
    PTTvals(h,1) = idxPPG(h) - idxECG(h);
    h = h+1;
end 



%% Smooth Data

% smoothGreenPPG = smooth(GreenPPG,7,'loess');
% figure;
% plot(rawTime,smoothGreenPPG);
% title('Green PPG Data');
% xlabel('Time (s)');
% ylabel('PPG Amplitude');
% legend('Green');

% Plot Data
% 
% figure;
% plot(filteredPPG(:,1)-min(filteredPPG(:,1))); %%rawTime(:,1),GreenPPG(:,1),rawTime(:,1),AmbientPPG(:,1));
% hold on;
% plot(-rawECG(:,1)+min(rawECG(:,:)));
% title('PPG & ECG Data');
% xlabel('Samples');
% ylabel('PPG/ECG Amplitude');
% 
% hold on
% %%figure;
% plot(idxPPG(:,1),datPPG(:,1)-min(filteredPPG(:,:)),'*');
% 
% plot(idxECG(:,1),-datECG(:,1)-min(rawECG(:,:)),'*');
% legend('Red','ECG','PPG peaks','ECG Peaks');

PTT = idxPPG(:,1)-idxECG(:,1);
avgPTT = mean(PTT(1:end));
avgPTTTime = avgPTT/200;
avgPTTTimeMs = avgPTTTime * 1000; 
SBPinitial = 119; 
DBPinitial = 83;  
PPinitial = SBPinitial - DBPinitial;
PIRinitial =   mean(datPPG);  


DBPvals = zeros(size(datPPG,1),1);  
k = 1; 
while k < size(datPPG,1) + 1
  
    DBPvals(k,1)= DBPinitial * (PIRinitial/datPPG(k,1));
    k = k+1;
end 
 
j = 1;
 SBPvals = zeros(size(DBPvals,1),1); 
while j < size(DBPvals,1) + 1
    SBPvals(j,1) = DBPvals(j,1) + PPinitial * ((avgPTT/PTT(j,1)).^2);
    j = j+1;
end 
