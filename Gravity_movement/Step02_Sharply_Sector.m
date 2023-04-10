clc
clear
data_loc='P:\Work_2022\IrrWaterUse\ML_Irr\WU_spatial\All_data_read\';
[Intersect_data, Intersect_infor]=xlsread([data_loc,'Zhou_polygon_to_ours_new.xlsx']);
Intersect_infor=Intersect_infor(2:end,:);

Irr=xlsread([data_loc,'Irr_data.xlsx'],'Irr_Ling_Zhou'); %灌溉用水 km3/year
Ind=xlsread([data_loc,'Industry_data.xlsx'],'Industry_Ling_Zhou'); %工业用水 km3/year
Domestic=xlsread([data_loc,'Domestic_data.xlsx'],'Domestic_Ling_Zhou'); %生活用水 km3/year
Total_WU=[Irr(:,1:2),Irr(:,3:end)+Ind(:,3:end)+Domestic(:,3:end)];

%% 5-year average
Irr_5year=Irr(:,1:2);
Ind_5year=Ind(:,1:2);
Domestic_5year=Domestic(:,1:2);
Total_WU_5year=Total_WU(:,1:2);
start_col=4;
for ii=1:11
    Irr_5year=[Irr_5year,mean(Irr(:,start_col:start_col+4),2)]; % 1970 refers to 1966-1970
    Ind_5year=[Ind_5year,mean(Ind(:,start_col:start_col+4),2)];
    Domestic_5year=[Domestic_5year,mean(Domestic(:,start_col:start_col+4),2)];
    Total_WU_5year=[Total_WU_5year,mean(Total_WU(:,start_col:start_col+4),2)];
    start_col=start_col+5;
end

%% Irr gravity movement
% Ref: Castro J, Gómez D, Tejada J. Polynomial calculation of the Shapley
% value based on sampling. Computers & Operations Research, 2009, 36(5):1726-1730.
% ===========================================================================
% Irr:1,Ind:2,Domestic:3
% 分三段：1970-1985，1985-2010，2010-2020，1970-2020
P3_sector_contribute=[];
TWU_move=[];
for jj=1:4
order=perms(1:3);
sector=(1:3)';
shi_x=zeros(3,1);
shi_y=zeros(3,1);
if jj==1
    P1=3;P2=5;
elseif jj==2
    P1=5;P2=11;
elseif jj==3
    P1=11;P2=13;
else
   P1=3;P2=13;
end
WU_before=[Irr_5year(:,P1),Ind_5year(:,P1),Domestic_5year(:,P1)];
WU_after=[Irr_5year(:,P2),Ind_5year(:,P2),Domestic_5year(:,P2)];
for i=1:6
    current_order=order(i,:)';
    WU_before_current=WU_before(:,current_order);
    WU_before_current_sum=[WU_before_current(:,1),sum(WU_before_current(:,1:2),2),sum(WU_before_current(:,1:3),2)];
    WU_after_current=WU_after(:,current_order);
    WU_after_current_sum=[WU_after_current(:,1),sum(WU_after_current(:,1:2),2),sum(WU_after_current(:,1:3),2)];
    
    delta_x=zeros(3,1);
    delta_y=zeros(3,1);
    for k=1:3
        if k==1
            % Intersect_data(:,16),lon
            % Intersect_data(:,17),lat
            % k==1，第一个变量单独的贡献；k>1表示该顺序下，其它变量的贡献。
            delta_x(k)=sum(Intersect_data(:,16).*WU_after_current(:,1))/sum(WU_after_current(:,1))...
                -sum(Intersect_data(:,16).*WU_before_current(:,1))/sum(WU_before_current(:,1));
            delta_y(k)=sum(Intersect_data(:,17).*WU_after_current(:,1))/sum(WU_after_current(:,1))...
                -sum(Intersect_data(:,17).*WU_before_current(:,1))/sum(WU_before_current(:,1));
        else
            Pre_x=sum(Intersect_data(:,16).*WU_after_current_sum(:,k))/sum(WU_after_current_sum(:,k))...
                -sum(Intersect_data(:,16).*WU_before_current_sum(:,k))/sum(WU_before_current_sum(:,k));
            Pre=sum(Intersect_data(:,16).*WU_after_current_sum(:,k-1))/sum(WU_after_current_sum(:,k-1))...
                -sum(Intersect_data(:,16).*WU_before_current_sum(:,k-1))/sum(WU_before_current_sum(:,k-1));
            delta_x(k)=Pre_x-Pre;
            
            Pre_y=sum(Intersect_data(:,17).*WU_after_current_sum(:,k))/sum(WU_after_current_sum(:,k))...
                -sum(Intersect_data(:,17).*WU_before_current_sum(:,k))/sum(WU_before_current_sum(:,k));
            Pre=sum(Intersect_data(:,17).*WU_after_current_sum(:,k-1))/sum(WU_after_current_sum(:,k-1))...
                -sum(Intersect_data(:,17).*WU_before_current_sum(:,k-1))/sum(WU_before_current_sum(:,k-1));
            delta_y(k)=Pre_y-Pre;
            
        end
    end
    [C,IA,IB] =intersect(sector,current_order);
    shi_x=shi_x+delta_x(IB);
    shi_y=shi_y+delta_y(IB);
end
Shaply_x_value=shi_x/6;
Shaply_y_value=shi_y/6;
P3_sector_contribute=[P3_sector_contribute;[Shaply_x_value,Shaply_y_value]];
TWU_move=[TWU_move;sum([Shaply_x_value,Shaply_y_value])];
end

%% 在TWU方向进行归因
Sector_TWU_Dir_contribute=[];
aa=1;
for hh=1:4
     TWU_move_temp=TWU_move(hh,:);
     irr_move_temp=P3_sector_contribute(aa,:);
     ind_move_temp=P3_sector_contribute(aa+1,:);
     Domestic_move_temp=P3_sector_contribute(aa+2,:);
     
     irr_move_contri=sum(TWU_move_temp.*irr_move_temp)/sqrt(TWU_move_temp(1)^2+TWU_move_temp(2)^2);
     ind_move_contri=sum(TWU_move_temp.*ind_move_temp)/sqrt(TWU_move_temp(1)^2+TWU_move_temp(2)^2);
     Domestic_move_contri=sum(TWU_move_temp.*Domestic_move_temp)/sqrt(TWU_move_temp(1)^2+TWU_move_temp(2)^2);
     Sector_TWU_Dir_contribute=[Sector_TWU_Dir_contribute;[irr_move_contri;ind_move_contri;Domestic_move_contri]];
     aa=aa+3;
end

%%
row_title={'Period','sector','Lon_dir','lat_dir','TWU_dir'};
period=[{'1970-1985','Irr'};{'1970-1985','Ind'};{'1970-1985','Domestic'};...
    {'1985-2010','Irr'};{'1985-2010','Ind'};{'1985-2010','Domestic'};...
    {'2010-2020','Irr'};{'2010-2020','Ind'};{'2010-2020','Domestic'};...
     {'1970-2020','Irr'};{'1970-2020','Ind'};{'1970-2020','Domestic'}];

xlswrite('Gravity_Movement_contribute_scetor.xlsx',[row_title;[period,num2cell([P3_sector_contribute,Sector_TWU_Dir_contribute])]]);

