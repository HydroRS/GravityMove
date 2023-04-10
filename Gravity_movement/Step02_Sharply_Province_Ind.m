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
province=unique(Irr_5year(:,2));

P3_sector_contribute=province;
TWU_move=[];
for jj=1:4
    
    if jj==1
        P1=3;P2=5;
    elseif jj==2
        P1=5;P2=11;
    elseif jj==3
        P1=11;P2=13;
    else
        P1=3;P2=13;
    end
    
    shi_x=zeros(31,1);
    shi_y=zeros(31,1);
    m=10000;
    cont=0;
    before_P=Ind_5year(:,P1);
    after_P=Ind_5year(:,P2);
    while cont<m
        if mod(cont,1000)==0&&cont~=0
            cont
        end
        
        % 构造随机顺序
        order=randperm(31);
        current_province=province(order);
        before_P_current=[];
        after_P_current=[];
        Intersect_data_new=[];
        for kk=1:31
            id0=find(Irr_5year(:,2)==current_province(kk));
            before_P_current=[before_P_current;[repmat(current_province(kk),length(id0),1),before_P(id0)]];
            after_P_current=[after_P_current;[repmat(current_province(kk),length(id0),1),after_P(id0)]];
            Intersect_data_new=[Intersect_data_new;[Intersect_data(id0,16),Intersect_data(id0,17)]];
        end
        
        % Shaply value
        delta_x=zeros(31,1);
        delta_y=zeros(31,1);
        for i=1:31
            id=find(ismember(before_P_current(:,1),current_province(i))~=0);
            if i==1
                % 1966-1980
                delta_x(i)=sum(Intersect_data_new(id,1).*after_P_current(id,2))/sum(after_P_current(id,2))...
                    -sum(Intersect_data_new(id,1).*before_P_current(id,2))/sum(before_P_current(id,2));
                delta_y(i)=sum(Intersect_data_new(id,2).*after_P_current(id,2))/sum(after_P_current(id,2))...
                    -sum(Intersect_data_new(id,2).*before_P_current(id,2))/sum(before_P_current(id,2));
                
            else
                Pre_x=sum(Intersect_data_new(1:id(end),1).*after_P_current(1:id(end),2))/sum(after_P_current(1:id(end),2))...
                    -sum(Intersect_data_new(1:id(end),1).*before_P_current(1:id(end),2))/sum(before_P_current(1:id(end),2));
                Pre=sum(Intersect_data_new(1:(id(1)-1),1).*after_P_current(1:(id(1)-1),2))/sum(after_P_current(1:(id(1)-1),2))...
                    -sum(Intersect_data_new(1:(id(1)-1),1).*before_P_current(1:(id(1)-1),2))/sum(before_P_current(1:(id(1)-1),2));
                delta_x(i)=Pre_x-Pre;
                
                Pre_y=sum(Intersect_data_new(1:id(end),2).*after_P_current(1:id(end),2))/sum(after_P_current(1:id(end),2))...
                    -sum(Intersect_data_new(1:id(end),2).*before_P_current(1:id(end),2))/sum(before_P_current(1:id(end),2));
                Pre=sum(Intersect_data_new(1:(id(1)-1),2).*after_P_current(1:(id(1)-1),2))/sum(after_P_current(1:(id(1)-1),2))...
                    -sum(Intersect_data_new(1:(id(1)-1),2).*before_P_current(1:(id(1)-1),2))/sum(before_P_current(1:(id(1)-1),2));
                delta_y(i)=Pre_y-Pre;
            end
        end
        [C,IA,IB] =intersect(province,current_province);
        shi_x=shi_x+delta_x(IB);
        shi_y=shi_y+delta_y(IB);
        %     shi_x=[shi_x,delta_x(IB)];
        %     shi_y=[shi_y,delta_y(IB)];
        cont=cont+1;
    end
    Shaply_x_value=shi_x/m;
    Shaply_y_value=shi_y/m;
    P3_sector_contribute=[P3_sector_contribute,[Shaply_x_value,Shaply_y_value]];
    TWU_move=[TWU_move,sum([Shaply_x_value,Shaply_y_value])];
end

%% 在TWU方向进行归因
Sector_TWU_Dir_contribute_all=[];
kk=1;
P3_sector_contribute_temp=P3_sector_contribute(:,2:end);
for mm=1:4
    TWU_move_temp=TWU_move(1,kk:kk+1);
    Sector_TWU_Dir_contribute=[];
    for hh=1:31
        
        province_move_temp=P3_sector_contribute_temp(hh,kk:kk+1);
        
        province_move_contri=sum(TWU_move_temp.*province_move_temp)/sqrt(TWU_move_temp(1)^2+TWU_move_temp(2)^2);
        Sector_TWU_Dir_contribute=[Sector_TWU_Dir_contribute;province_move_contri];
        
    end
    Sector_TWU_Dir_contribute_all=[Sector_TWU_Dir_contribute_all,Sector_TWU_Dir_contribute];
    kk=kk+2;
end
%%
row_title={'provinceId','P1_lon','P1_lat','P2_lon','P2_lat','P3_lon','P3_lat','P_lon','P_lat','P1_TWU_dir','P2_TWU_dir','P3_TWU_dir','P_TWU_dir'};
xlswrite('Ind_Gravity_Movement_region_contribute.xlsx',[row_title;num2cell([P3_sector_contribute,Sector_TWU_Dir_contribute_all])]);
