function C = Function_Concentration(WU,P,TWU )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% P=Pop_5year(:,3);
% TWU=Total_WU_5year(:,3);
% WU=Irr_5year(:,3);
Mti=TWU./P; % 人均总用水
Mai=WU./P; % 人均总用水
Pi=P/sum(P); % 人口比例
PiMi=Pi.*Mai; 
Wi=PiMi/(sum(WU)/sum(P));% 区域i用水量占全国总用水比例=WUi/sum(WU)
[order,id]= sort(Mti,'ascend');
Qi=cumsum(Wi(id));
C=1-sum(Pi(id).*(2*Qi-Wi(id)));

end

