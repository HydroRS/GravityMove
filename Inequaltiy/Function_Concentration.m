function C = Function_Concentration(WU,P,TWU )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% P=Pop_5year(:,3);
% TWU=Total_WU_5year(:,3);
% WU=Irr_5year(:,3);
Mti=TWU./P; % �˾�����ˮ
Mai=WU./P; % �˾�����ˮ
Pi=P/sum(P); % �˿ڱ���
PiMi=Pi.*Mai; 
Wi=PiMi/(sum(WU)/sum(P));% ����i��ˮ��ռȫ������ˮ����=WUi/sum(WU)
[order,id]= sort(Mti,'ascend');
Qi=cumsum(Wi(id));
C=1-sum(Pi(id).*(2*Qi-Wi(id)));

end

