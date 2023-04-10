function Gini = Function_Gini(WU,P )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% P=Pop_5year(:,3);
% WU=Irr_5year(:,3);
Mi=WU./P; % 人均用水
Pi=P/sum(P); % 人口比例
PiMi=Pi.*Mi; 
Wi=PiMi/(sum(WU)/sum(P));% 区域i用水量占全国总用水比例=WUi/sum(WU)
[order,id]= sort(Mi,'ascend');
Qi=cumsum(Wi(id));
Gini=1-sum(Pi(id).*(2*Qi-Wi(id)));

end

