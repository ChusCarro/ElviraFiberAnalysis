function [conduction, CV, APD90] = testConduction(V,dt,numStim,dxOut)

minDiffV = 10;% mV
minPercV = 0.75;% 
CV = cell(length(V(1,:)),1);
APD90_c = cell(length(V(1,:)),1);
APD_time = cell(length(V(1,:)),1);
maxV = cell(length(V(1,:)),1);
minV = cell(length(V(1,:)),1);

n_cells = length(V(1,:));
conduction = false;
CV = [];
APD90 = [];

for i=1:n_cells
    [APD90_c{i},APD_time{i},maxV{i},minV{i}]= calculateAPD(V(:,i),dt);
end

for i=1:n_cells
    if(numStim~=length(APD90_c{i}))
        return;
    end
end

maxV = cell2mat(maxV);
minV = cell2mat(minV);

for i=1:numStim
   differences = maxV(:,i) - minV(:,i);
   biggerThanMinDiffV = find(differences<minDiffV,1);
   if(~isempty(biggerThanMinDiffV))
       return
   end
   
   diff_matrix = (1./differences)*differences';
   
   biggerThanMinPercV = find(diff_matrix<minPercV,1);
   if(~isempty(biggerThanMinPercV))
       return;
   end
end

APD90 = mean(cell2mat(APD90_c));
APD_time_v = cell2mat(APD_time);
CV = (n_cells-1)*dxOut*1000./(APD_time_v(end,:)-APD_time_v(1,:));
conduction = true;
