function Gini = Function_Gini(WU,P )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% P=Pop_5year(:,3);
% WU=Irr_5year(:,3);
Mi=WU./P; % �˾���ˮ
Pi=P/sum(P); % �˿ڱ���
PiMi=Pi.*Mi; 
Wi=PiMi/(sum(WU)/sum(P));% ����i��ˮ��ռȫ������ˮ����=WUi/sum(WU)
[order,id]= sort(Mi,'ascend');
Qi=cumsum(Wi(id));
Gini=1-sum(Pi(id).*(2*Qi-Wi(id)));

end

