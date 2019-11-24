data = importdata('bidmc_data.mat');
ppg_vals = zeros(6001, 53);
ekg_vals = zeros(6001, 53);
n = 1;
x = 1;
DBPinitial = 80; 
SBPinitial = 120;
MBPinitial = DBPinitial  + (1/3)*(SBPinitial - DBPinitial); 
PPinitial = SBPinitial - DBPinitial;
E0 = 667;
a = 0.017;
A = E0 * exp(a*MBPinitial); 

PTTinitial = 13;
while n < 54
    while x < 6002
        ppg_vals(x,n) = data(n).ppg.v(x);
        ekg_vals(x,n) = data(n).ekg.v(x);
        
        x = x+1;
    end
    x = 1;
    n = n+1;
end
dppg_vals = diff(ppg_vals);

[PPGPeaks,locs] = findpeaks(ppg_vals(:,1),'MinPeakDistance',50, 'MinPeakHeight', 0.5);
[ECGPeaks,locs2] = findpeaks(ekg_vals(:,1),'MinPeakDistance',45, 'MinPeakHeight', 0.2);
PIRinitial = mean(PPGPeaks); 
[DPPGPeaks,locs3] = findpeaks(dppg_vals(:,1),'MinPeakDistance',50);
% figure
% hold on
% findpeaks(ekg_vals(:,1),'MinPeakDistance',45, 'MinPeakHeight', 0.2);
% findpeaks(ppg_vals(:,1),'MinPeakDistance',50, 'MinPeakHeight', 0.5);
h = 1;
PTTvals = zeros(size(ECGPeaks,1),1); 
while h < size(ECGPeaks,1) + 1
  
    PTTvals(h,1) = abs(locs3(h)-locs2(h));
    h = h+1;
end 


k = 1;

DBPvals = zeros(size(PPGPeaks,1),1); 
while k < size(PPGPeaks,1) + 1
  
    DBPvals(k,1)= DBPinitial * (PIRinitial/PPGPeaks(k,1));
    k = k+1;
end 


% DBPvals2 = zeros(size(PPGPeaks,1),1); 
% while k < size(PPGPeaks,1) + 1
%   
%     DBPvals(k,1)= MBPinitial + A  (PPinitial/3) * ((PTTinitial/PTTvals(j,1)).^2;
%     k = k+1;
% end 


j = 1;
 SBPvals = zeros(size(DBPvals,1),1); 
while j < size(DBPvals,1) + 1
    SBPvals(j,1) = DBPvals(j,1) + PPinitial * ((PTTinitial/PTTvals(j,1)).^2);
    j = j+1;
end 
figure(1); 



