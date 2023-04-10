function PiWiGI_sum = Function_GI_calculate( province,city_id,WU_city,P_city,WU_province,P_province )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
PiWiGI_sum=0;
for jj=1:31
    id=find(city_id==province(jj));
    GI=Function_Gini(WU_city(id),P_city(id));
    PiWiGI=P_province(jj)/sum(P_province)*WU_province(jj)/sum(WU_province)*GI;
    PiWiGI_sum=PiWiGI_sum+PiWiGI;
end


end

