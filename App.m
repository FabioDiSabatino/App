function  App()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes heres
%% Init serial port
clear all;
clc;
%Custom some properties before open the serial communication
serialPort=initSerial("COM3",9600,128);
%
%  Set 1 for 9DOF
%  Set 2 for 6DOF
%
ComputationMode=1;

%% App in Low Computation



%% Drift analysis
clearvars -except Data ACC;

f=figure;

p = uipanel('Parent',f,'BorderType','none');
p.Title = 'Velocità angolari misurate'; 
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';


ax1=subplot(3,1,1,'Parent',p);

angularX= animatedline(0,0,'Color','b');


ax1.YLim = [-4 4];
ax1.YGrid = 'on';
ax1.XGrid = 'on';
xlabel('tempo (s)');
ylabel('\omega_x (dps)');
title('velocità angolare sull''asse X (rad/s)');

ax1=subplot(3,1,2,'Parent',p);

angularY= animatedline(0,0,'Color','r');


ax1.YLim = [-4 4];
ax1.YGrid = 'on';
ax1.XGrid = 'on';
xlabel('tempo (s)');
ylabel('\omega_y (dps)');

title('velocità angolare sull''asse Y (rad/s)');


ax1=subplot(3,1,3,'Parent',p);

angularZ= animatedline(0,0,'Color','g');


ax1.YLim = [-4 4];
ax1.YGrid = 'on';
ax1.XGrid = 'on';
xlabel('tempo (s)');
ylabel('\omega_z (dps)');

title('velocità angolare sull''asse z (rad/s)');

g=figure;

p = uipanel('Parent',g,'BorderType','none'); 
p.Title = 'Stima della posizione - YAW'; 
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';

ax1=subplot(2,1,1,'Parent',p);
title('Matlab');
yawLine= animatedline(0,0,'Color','b');


ax1.YLim = [-180 180];
ax1.YGrid = 'on';
xlabel('tempo (s)');
ylabel('gradi (°)');

ax2=subplot(2,1,2,'Parent',p);
yawSTMLine= animatedline(0,0,'Color','r');

title('STM');
ax2.YGrid = 'on';
ax2.YLim = [-180 180];
xlabel('tempo (s)');
ylabel('gradi (°)');



stop = false;

%Discrete time variable
T=0.01;

qk=[0 0 0 0].';

p_qk=0;


Pk=eye(4);

p_Pk=eye(4);

startTime = datetime('now');

data=strings(1,10000);
acc=zeros(6000,3);
gyro=zeros(6000,3);
rotation=zeros(6000,3);

count=1;
clc;
 [count, ~]=size(Data);
 count=count-1;
%-----------------------------Parsing data -------------------------------%
for c=1:count
    
    [accData,gyroData,~,rotationData]=read(Data(c),0);
    
    %Acceleration on x-axe
    acc(c,1)=accData(1);
    
    %Acceleration on y-axe
    acc(c,2)=accData(2);
    
    %Acceleration on z-axe
    acc(c,3)=accData(3);
    
    %Angular velocity on x-axe
    gyro(c,1)=gyroData(1);
    
    %Angular velocity on y-axe
    gyro(c,2)=gyroData(2);
    
    %Angular velocity on z-axe
    gyro(c,3)=gyroData(3);
    
    %Yaw
    rotation(c,1)=rotationData(1);
    
    %Pitch
    rotation(c,2)=rotationData(2);
    
    %Roll
    rotation(c,3)=rotationData(3);
    
    
end




%-----------------------------Elaboration data ---------------------------%
 
    
for c=1:count
    
    %--------------------Stage 0:Angular position estimation -------------%
    
    gyroRaw=[gyro(c,1),gyro(c,2),gyro(c,3)];
    [qk,Pk] = Stage0(gyroRaw,p_qk,p_Pk,T);
    
  
     
    %--------------------Stage 1:correction position----------------------%

    accRaw=[acc(c,1),acc(c,2),acc(c,3)];
    [qk1, Pk1]= Stage1(accRaw,qk,Pk);
    
    [yaw,pitch,roll]=quat2angle(qk1');
    
    yaw=yaw*180/pi;
    pitch=pitch*180/pi;
    roll=roll*180/pi;
    
        
    
    %Feedbacks loop 
     p_qk=qk1;
     p_Pk=Pk1;
     
     %-------------------------------Display data--------------------------%
    
    
    addpoints(yawLine,c*T,yaw);
    addpoints(yawSTMLine,c*T,rotation(c,1));
    
    addpoints(angularX,c*T,gyro(c,1)*180/pi);
    addpoints(angularY,c*T,gyro(c,2)*180/pi);
    addpoints(angularZ,c*T,gyro(c,3)*180/pi);
   
end

%Acc norm
modulAcc= zeros(12000,1);
for c=1:count
    modulAcc(c)=norm(ACC(c,1:3));
end
   



%% App in Comparing mode

clearvars -except Data;

f=figure;

p = uipanel('Parent',f,'BorderType','none'); 
p.Title = 'Stima della posizione - ROLL'; 
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';

ax1=subplot(2,1,1,'Parent',p);
title('Matlab');
rollLine= animatedline(0,0,'Color','b');


ax1.YLim = [-180 180];
ax1.YGrid = 'on';
xlabel('tempo (s)');
ylabel('gradi (°)');

ax2=subplot(2,1,2,'Parent',p);
rollSTMLine= animatedline(0,0,'Color','r');

title('STM');
ax2.YGrid = 'on';
ax2.YLim = [-180 180];
xlabel('tempo (s)');
ylabel('gradi (°)');

g=figure;

p = uipanel('Parent',g,'BorderType','none'); 
p.Title = 'Stima della posizione - YAW'; 
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';

ax1=subplot(2,1,1,'Parent',p);
title('Matlab');
yawLine= animatedline(0,0,'Color','b');


ax1.YLim = [-180 180];
ax1.YGrid = 'on';
xlabel('tempo (s)');
ylabel('gradi (°)');

ax2=subplot(2,1,2,'Parent',p);
yawSTMLine= animatedline(0,0,'Color','r');

title('STM');
ax2.YGrid = 'on';
ax2.YLim = [-180 180];
xlabel('tempo (s)');
ylabel('gradi (°)');

h=figure;

p = uipanel('Parent',h,'BorderType','none'); 
p.Title = 'Stima della posizione - PITCH'; 
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';

ax1=subplot(2,1,1,'Parent',p);
title('Matlab');
pitchLine= animatedline(0,0,'Color','b');


ax1.YLim = [-180 180];
ax1.YGrid = 'on';
xlabel('tempo (s)');
ylabel('gradi (°)');

ax2=subplot(2,1,2,'Parent',p);
pitchSTMLine= animatedline(0,0,'Color','r');

title('STM');
ax2.YGrid = 'on';
ax2.YLim = [-180 180];
xlabel('tempo (s)');
ylabel('gradi (°)');

stop = false;

%Discrete time variable
T=0.01;

qk=[0 0 0 0].';

p_qk=0;


Pk=eye(4);

p_Pk=eye(4);

startTime = datetime('now');

data=strings(1,10000);
acc=zeros(6000,3);
gyro=zeros(6000,3);
rotation=zeros(6000,3);

count=1;
clc;
%flushinput(serialPort)
%while ~stop
    
    %-----------------------------Read data sensor------------------------%
    %data(count)=fgetl(serialPort);
    %count=count+1;
    
     % Get current time
     %t =  datetime('now') - startTime;
     
    % Check stop condition
     %if(seconds(t)>10)
         stop=true;
     %end
     
%end
%count=count-1;
 [count, ~]=size(Data);
 count=count-1;
%-----------------------------Parsing data -------------------------------%
for c=1:count
    
    [accData,gyroData,~,rotationData]=read(Data(c),0);
    
    %Acceleration on x-axe
    acc(c,1)=accData(1);
    
    %Acceleration on y-axe
    acc(c,2)=accData(2);
    
    %Acceleration on z-axe
    acc(c,3)=accData(3);
    
    %Angular velocity on x-axe
    gyro(c,1)=gyroData(1);
    
    %Angular velocity on y-axe
    gyro(c,2)=gyroData(2);
    
    %Angular velocity on z-axe
    gyro(c,3)=gyroData(3);
    
    %Magnetic field on x-axe
    %magneto(c,1)=gyroData(1);
    
    %Magnetic field on y-axe
    %magneto(c,2)=gyroData(2);
    
    %Magnetic field on z-axe
    %magneto(c,3)=gyroData(3);
    
    %Yaw
    rotation(c,1)=rotationData(1);
    
    %Pitch
    rotation(c,2)=rotationData(2);
    
    %Roll
    rotation(c,3)=rotationData(3);
    
    
end

%-----------------------------Elaboration data ---------------------------%

for c=1:count
    
    %--------------------Stage 0:Angular position estimation -------------%
    
    gyroRaw=[gyro(c,1),gyro(c,2),gyro(c,3)];
    [qk,Pk] = Stage0(gyroRaw,p_qk,p_Pk,T);
    
  
     
    %--------------------Stage 1:correction position----------------------%

    accRaw=[acc(c,1),acc(c,2),acc(c,3)];
    [qk1, Pk1]= Stage1(accRaw,qk,Pk);
    
   
    
        
    
    
     
    %--------------------Stage 2:correction position----------------------%
   % magnetoRaw=[magneto(c,1),magneto(c,2),magneto(c,3)];
    %[qk2, Pk2]= Stage2(magnetoRaw,qk1,Pk1);
    [yaw,pitch,roll]=quat2angle(qk1');
    
    yaw=yaw*180/pi;
    pitch=pitch*180/pi;
    roll=roll*180/pi;
    
        
    
    %Feedbacks loop 
     p_qk=qk1;
     p_Pk=Pk1;
     
     %-------------------------------Display data--------------------------%
    
    addpoints(rollLine,c*T,roll);
    addpoints(rollSTMLine,c*T,rotation(c,3));
    
    addpoints(pitchLine,c*T,pitch);
    addpoints(pitchSTMLine,c*T,rotation(c,2));
    
    addpoints(yawLine,c*T,yaw);
    addpoints(yawSTMLine,c*T,rotation(c,1));
    
end
    
 


%% Close serial connection

fclose(serialPort);
clc;




end

