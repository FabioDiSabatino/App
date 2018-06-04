function  App()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes heres
%% Init serial port
clear all;
clc;
%Custom some properties before open the serial communication
serialPort=initSerial("COM3",9600,128);

%% App in Low Computation



%% App in High Computation 


%% App in Comparing mode

clearvars -except serialPort;

f=figure;

p = uipanel('Parent',f,'BorderType','none'); 
p.Title = 'Stima della posizione'; 
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';

ax1=subplot(2,1,1,'Parent',p);
title('Matlab');
rollLine= animatedline(0,0,'Color','b');


ax1.YLim = [-180 180];
xlabel('tempo (s)');
ylabel('gradi (°)');

ax2=subplot(2,1,2,'Parent',p);
rollSTMLine= animatedline(0,0,'Color','r');

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
flushinput(serialPort)
while ~stop
    
    %-----------------------------Read data sensor------------------------%
    data(count)=fgetl(serialPort);
    count=count+1;
    
     % Get current time
     t =  datetime('now') - startTime;
     
    % Check stop condition
     if(seconds(t)>10)
         stop=true;
     end
     
end
count=count-1;

%-----------------------------Parsing data -------------------------------%
for c=1:count
    
    [accData,gyroData,rotationData]=read(data(c));
    
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
    roll=-roll*180/pi;
    
        
    
    %Feedbacks loop 
     p_qk=qk1;
     p_Pk=Pk1;
     
     %-------------------------------Display data--------------------------%
    
    addpoints(rollLine,c*T,roll);
    addpoints(rollSTMLine,c*T,rotation(c,3));
end
    
 


%% Close serial connection

fclose(serialPort);
clc;




end

