function Gini_contribute = Function_sector_factor( Irr_temp,IrrArea_temp,WUI, Pop)

% Irr_temp=Irr_5year(:,3);
% IrrArea_temp=IrrArea_5year(:,3);
% Pop=Pop_5year(:,3);
% WUI=Irr_temp./IrrArea_temp;

% A=(sum(IrrArea_temp)/sum(Pop)).*Pop;

Gini_contribute_IrrArea = Function_Concentration(IrrArea_temp, Pop,Irr_temp);
Gini_contribute_IrrWUI = Function_Concentration(WUI, Pop,Irr_temp);
Gini_contribute_Irr = Function_Concentration(Irr_temp, Pop,Irr_temp);
% ×¢Òâ½»»»Ë³Ðò
shi=[[Gini_contribute_IrrArea;Gini_contribute_Irr-Gini_contribute_IrrArea],[Gini_contribute_Irr-Gini_contribute_IrrWUI;Gini_contribute_IrrWUI]];
Gini_contribute=sum(shi,2)/2;

Gini_contribute_IrrArea = Function_Concentration(IrrArea_temp, Pop,Irr_temp);
Gini_contribute_IrrWUI = Function_Concentration(WUI, Pop,Irr_temp);
Gini_contribute_Irr = Function_Concentration(Irr_temp, Pop,Irr_temp);
% ×¢Òâ½»»»Ë³Ðò
shi=[[Gini_contribute_IrrArea;Gini_contribute_Irr-Gini_contribute_IrrArea],[Gini_contribute_Irr-Gini_contribute_IrrWUI;Gini_contribute_IrrWUI]];
Gini_contribute=sum(shi,2)/2;

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Irr_temp=Irr_5year(:,3);
% IrrArea_temp=IrrArea_5year(:,3);
% Pop=Pop_5year(:,3);
% WUI=Irr_temp./IrrArea_temp;
% A=repmat(mean(IrrArea_temp),340,1);
% B=repmat(mean(WUI),340,1);
% D=(sum(Irr_temp)/sum(Pop)).*Pop;
% A=IrrArea_temp.*sqrt(D);
% B=(sum(WUI)/sum(Pop)).*Pop;
% A=(sum(IrrArea_temp)/sum(Pop)).*Pop;
% D1=IrrArea_temp-A;
% B=(sum(WUI)/sum(Pop)).*Pop;
% D2=WUI-B;
% 
% AD1_Concentrate = Function_Concentration(0.5*A.*WUI,Pop,Irr_temp );
% AD2_Concentrate = Function_Concentration(0.5*IrrArea_temp.*B,Pop,Irr_temp );
% AD1normal_Concentrate = Function_Concentration(0.5*(D1.*WUI+D2.*IrrArea_temp),Pop,Irr_temp );
% 
% Porportion=[sum(0.5*A.*WUI)./sum(Irr_temp),sum(0.5*IrrArea_temp.*B)./sum(Irr_temp),sum(0.5*(D1.*WUI+D2.*IrrArea_temp))./sum(Irr_temp)];
% Gini_contribute=([AD1_Concentrate,AD2_Concentrate,AD1normal_Concentrate].*Porportion);

% A_Normal=IrrArea_temp-A;
% B_Normal=WUI-B;
% A_Normal_mutip_B=A_Normal.*B;
% B_Normal_mutip_A=B_Normal.*A;
% Normal_Normal=A_Normal.*B_Normal;

% AB_Concentrate = Function_Concentration(A.*B,Pop,Irr_temp );
% ABnormal_Concentrate = Function_Concentration(B_Normal_mutip_A,Pop,Irr_temp );
% BAnormal_Concentrate = Function_Concentration(A_Normal_mutip_B,Pop,Irr_temp );
% Double_Normal_Concentrate = Function_Concentration(Normal_Normal,Pop,Irr_temp );
% Porportion=[sum(A.*B)./sum(Irr_temp),sum(B_Normal_mutip_A)./sum(Irr_temp),sum(A_Normal_mutip_B)./sum(Irr_temp),sum(Normal_Normal)./sum(Irr_temp)];
% Gini_contribute=([AB_Concentrate,ABnormal_Concentrate,BAnormal_Concentrate,Double_Normal_Concentrate].*Porportion);

end

