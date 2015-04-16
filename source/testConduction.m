function [conduction, CV, APD90] = testConduction(V,dt,numStim,dxOut)

CV = cell(length(V(1,:)),1);

APD90_c = cell(length(V(1,:)),1);
APD_time = cell(length(V(1,:)),1);
maxV = cell(length(V(1,:)),1);
minV = cell(length(V(1,:)),1);

n_cells = length(V(1,:));
conduction = false;

for i=1:n_cells
    [APD90_c{i},APD_time{i},maxV{i},minV{i}]= calculateAPD(V(:,i),dt);
end

n=length(APD90_c{1});

if(n==0)
    conduction=false;
    CV=[];
    APD90=[];
    return;
end

for i=2:n_cells
    if(n~=length(APD90_c{i}))
        return;
    end
end

conduction_v = true(1,n);

maxV = cell2mat(maxV);
minV = cell2mat(minV);

for i=1:n
   differences = maxV(:,i) - minV(:,i);
   differences_rel = (maxV(:,i) - minV(:,i))./abs(minV(:,i));
   five_per = find(differences_rel<0.1,1);
   if(~isempty(five_per))
       conduction_v(i)=false;
       continue
   end
   
%   diff_matrix = (1./differences)*differences';   
   
%   seventy_per = find(diff_matrix<0.7,1);
%   if(~isempty(seventy_per))
%       conduction_v(i)=false;
%       continue
%   end
end

APD90 = mean(cell2mat(APD90_c));
APD_time_v = cell2mat(APD_time));
CV = (n_cells-1)*dxOut*1000./(APD_time(:,end)-APD_time(:,1));

APD90(~conduction_v)=[];
CV(~conduction_v)=[];

if(~isempty(APD90))
    conduction = true;
end
