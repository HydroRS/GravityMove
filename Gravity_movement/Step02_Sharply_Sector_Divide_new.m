clc
clear
data_loc='P:\Work_2022\IrrWaterUse\ML_Irr\WU_spatial\All_data_read\';
[Intersect_data, Intersect_infor]=xlsread([data_loc,'Zhou_polygon_to_ours_new.xlsx']);
Intersect_infor=Intersect_infor(2:end,:);

Irr=xlsread([data_loc,'Irr_data.xlsx'],'Irr_Ling_Zhou'); %灌溉用水 km3/year
IrrArea=xlsread([data_loc,'IrrArea_data.xlsx'],'IrrArea_Ling_Zhou'); %灌溉面积： Kha

Ind=xlsread([data_loc,'Industry_data.xlsx'],'Industry_Ling_Zhou'); %工业用水 km3/year
IndGVA=xlsread([data_loc,'IndustryGVA_data.xlsx'],'IndustryGVA_Ling_Zhou'); %工业增加值：billion Yuan

Domestic=xlsread([data_loc,'Domestic_data.xlsx'],'Domestic_Ling_Zhou'); %生活用水 km3/year
Population=xlsread([data_loc,'Population_data.xlsx'],'Population_Ling_Zhou'); %生活用水 km3/year

Total_WU=[Irr(:,1:2),Irr(:,3:end)+Ind(:,3:end)+Domestic(:,3:end)];

%% 5-year average
Irr_5year=Irr(:,1:2);
IrrArea_5year=Irr(:,1:2);
IrrWUI_5year=Irr(:,1:2);

Ind_5year=Ind(:,1:2);
IndGVA_5year=Ind(:,1:2);
IndWUI_5year=Ind(:,1:2);

Domestic_5year=Domestic(:,1:2);
Pop_5year=Domestic(:,1:2);
DomesticWUI_5year=Domestic(:,1:2);

Total_WU_5year=Total_WU(:,1:2);
start_col=4;
for ii=1:11
    Irr_5year=[Irr_5year,mean(Irr(:,start_col:start_col+4),2)]; % 1970 refers to 1966-1970
    IrrArea_5year=[IrrArea_5year,mean(IrrArea(:,start_col:start_col+4),2)];
    IrrWUI_5year=[IrrWUI_5year,mean(Irr(:,start_col:start_col+4),2)./mean(IrrArea(:,start_col:start_col+4),2)];
    
    Ind_5year=[Ind_5year,mean(Ind(:,start_col:start_col+4),2)];
    IndGVA_5year=[IndGVA_5year,mean(IndGVA(:,start_col:start_col+4),2)];
    IndWUI_5year=[IndWUI_5year,mean(Ind(:,start_col:start_col+4),2)./mean(IndGVA(:,start_col:start_col+4),2)];
    
    Domestic_5year=[Domestic_5year,mean(Domestic(:,start_col:start_col+4),2)];
     Pop_5year=[Pop_5year,mean(Population(:,start_col:start_col+4),2)];
    DomesticWUI_5year=[DomesticWUI_5year,mean(Domestic(:,start_col:start_col+4),2)./mean(Population(:,start_col:start_col+4),2)];
    
    Total_WU_5year=[Total_WU_5year,mean(Total_WU(:,start_col:start_col+4),2)];
    start_col=start_col+5;
end

%% Irr gravity movement
% Ref: Castro J, Gómez D, Tejada J. Polynomial calculation of the Shapley
% value based on sampling. Computers & Operations Research, 2009, 36(5):1726-1730.
% E2-E1=(A1+ΔA)*(B1+ΔB)-A1*B1=A1ΔB+B1ΔA+ΔA*ΔB
% E2=E1+A1ΔB+B1ΔA+ΔA*ΔB;
% A:IrrArea, B:IrrWUI, E:Irr
% E1+A1*delta_IrrArea:palyer01,E1+B1*delta_IrrWUI:palyer01,E1+delta_IrrArea*delta_IrrWUI:palyer01
% =================================================================================================
P3_sector_contribute_all=[];
TWU_move_all=[];
for jj=1:4 % 4 period
    P3_sector_contribute=[];
   TWU_move=[];
    for kk=1:3 % 3 sectors
%         order=perms(1:3);
%         sector=(1:3)';
%         shi_x=zeros(3,1);
%         shi_y=zeros(3,1);
        
        if jj==1
            P1=3;P2=5;
        elseif jj==2
            P1=5;P2=11;
        elseif jj==3
            P1=11;P2=13;
        else
            P1=3;P2=13;
        end
        if kk==1
             WU_before=[IrrArea_5year(:,P1),IrrWUI_5year(:,P1)];
             WU_after=[IrrArea_5year(:,P2),IrrWUI_5year(:,P2)];
%             delta_IrrArea=IrrArea_5year(:,P2)-IrrArea_5year(:,P1);
%             delta_IrrWUI=IrrWUI_5year(:,P2)-IrrWUI_5year(:,P1);
%               WU_after=[IrrWUI_5year(:,P1).*delta_IrrArea,IrrArea_5year(:,P1).*delta_IrrWUI,delta_IrrArea.*delta_IrrWUI];
        elseif kk==2
              WU_before=[IndGVA_5year(:,P1),IndWUI_5year(:,P1)];
             WU_after=[IndGVA_5year(:,P2),IndWUI_5year(:,P2)];
%             WU_before=Ind_5year(:,P1);
%             delta_IrrArea=IndGVA_5year(:,P2)-IndGVA_5year(:,P1);
%             delta_IrrWUI=IndWUI_5year(:,P2)-IndWUI_5year(:,P1);
%             WU_after=[IndWUI_5year(:,P1).*delta_IrrArea,IndGVA_5year(:,P1).*delta_IrrWUI,delta_IrrArea.*delta_IrrWUI];
        else
             WU_before=[Pop_5year(:,P1),DomesticWUI_5year(:,P1)];
             WU_after=[Pop_5year(:,P2),DomesticWUI_5year(:,P2)];
%             WU_before=Domestic_5year(:,P1);
%             delta_IrrArea=Pop_5year(:,P2)-Pop_5year(:,P1);
%             delta_IrrWUI=DomesticWUI_5year(:,P2)-DomesticWUI_5year(:,P1);
%             WU_after=[DomesticWUI_5year(:,P1).*delta_IrrArea,Pop_5year(:,P1).*delta_IrrWUI,delta_IrrArea.*delta_IrrWUI];
 
        end
              
        order=perms(1:2);
        sector=(1:2)'; %IrrAreaContri,IrrWUIContri
        shi_x=zeros(2,1);
        shi_y=zeros(2,1);     
      
        for i=1:2
            current_order=order(i,:)';
            WU_before_current=WU_before(:,current_order);
%             WU_before_current=repmat(WU_before,1,3);
            WU_before_current_sum=[WU_before_current(:,1),WU_before_current(:,1).*WU_before_current(:,2)];
            %     WU_before_current_sum=[WU_before_current(:,1),sum(WU_before_current(:,1:2),2),sum(WU_before_current(:,1:3),2)];
            WU_after_current=WU_after(:,current_order);
            WU_after_current_sum=[WU_after_current(:,1),WU_after_current(:,1).*WU_after_current(:,2)];
            
            delta_x=zeros(2,1);
            delta_y=zeros(2,1);
            for k=1:2
                if k==1
                    delta_x(k)=sum(Intersect_data(:,16).*WU_after_current_sum(:,1))/sum(WU_after_current_sum(:,1))...
                        -sum(Intersect_data(:,16).*WU_before_current_sum(:,1))/sum(WU_before_current_sum(:,1));
                    delta_y(k)=sum(Intersect_data(:,17).*WU_after_current_sum(:,1))/sum(WU_after_current_sum(:,1))...
                        -sum(Intersect_data(:,17).*WU_before_current_sum(:,1))/sum(WU_before_current_sum(:,1));
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
        Shaply_x_value=shi_x/2;
        Shaply_y_value=shi_y/2;
        
        P3_sector_contribute=[P3_sector_contribute,[Shaply_x_value,Shaply_y_value]];
        TWU_move=[TWU_move,sum([Shaply_x_value,Shaply_y_value])];
    end
    P3_sector_contribute_all=[P3_sector_contribute_all;P3_sector_contribute];
    TWU_move_all=[TWU_move_all;TWU_move];
end

%% 在TWU方向进行归因
Sector_TWU_Dir_contribute_all=[];
aa=1;
for hh=1:4
    bb=1;
    Sector_TWU_Dir_contribute=[];
    for kk=1:3
     TWU_move_temp=TWU_move_all(hh,bb:bb+1);
     scale_move_temp=P3_sector_contribute_all(aa,bb:bb+1);
     intensity_move_temp=P3_sector_contribute_all(aa+1,bb:bb+1);
    
     scale_move_contri=sum(TWU_move_temp.*scale_move_temp)/sqrt(TWU_move_temp(1)^2+TWU_move_temp(2)^2);
     intensity_move_contri=sum(TWU_move_temp.*intensity_move_temp)/sqrt(TWU_move_temp(1)^2+TWU_move_temp(2)^2);
     
     Sector_TWU_Dir_contribute=[Sector_TWU_Dir_contribute,[scale_move_contri;intensity_move_contri]];
     bb=bb+2;
    end
    Sector_TWU_Dir_contribute_all=[Sector_TWU_Dir_contribute_all;Sector_TWU_Dir_contribute];
    aa=aa+2;
end

%%

row_title={'Period','sector','Irr_Lon_dir','Irr_lat_dir','Ind_Lon_dir','Ind_lat_dir','Dom_Lon_dir','Dom_lat_dir','Irr_TWU_dir','Ind_TWU_dir','Dom_TWU_dir'};
period=[{'1970-1985','Scale'};{'1970-1985','intensity'};...
    {'1985-2010','Scale'};{'1985-2010','intensity'};...
    {'2010-2020','Scale'};{'2010-2020','intensity'};...
     {'1970-2020','Scale'};{'1970-2020','intensity'}];

xlswrite('Gravity_Movement_contribute_scetor_divide.xlsx',[row_title;[period,num2cell([P3_sector_contribute_all,Sector_TWU_Dir_contribute_all])]]);
