function  main()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Init serial port
clear all;
clc;
%Custom some properties before open the serial communication
serialPort=initSerial("COM3",9600,50);




%% App

clearvars -except serialPort;
%figure
%title('Graph of Estimated position ');

%rollLine= animatedline(0,0,'Color','r');
%pitchLine= animatedline(0,0,'Color','b');
%rollM= animatedline(0,0,'Color','m');
%pitchM= animatedline(0,0,'Color','y');

%ax = gca;
%ax.YGrid = 'on';
%ax.YLim = [-270 270];
%xlabel('time elapsed (T)');
%ylabel('Euler Angles');

%legend('Roll','Pitch','RollM','PitchM');

stop = false;

%Discrete time variable
%T=0;

%qk=[0 0 0 0].';

%p_qk=0;


%Pk=eye(4);

%p_Pk=eye(4);

startTime = datetime('now');

times=zeros(1,10000);
packetsID=zeros(1,10000);
packetS=strings(1,10000);
count=1;
avgTime=0;
clc;
flushinput(serialPort)
tic
while ~stop
     %tic
    %-----------------------------Read data sensor------------------------%
    %[acc,gyro,eulerMicro]=read(serialPort);
    %--------------------Stage 0:Angular position estimation -------------%
    
    %[qk,Pk] = Stage0(gyro,p_qk,p_Pk,T);
    
    t=toc;
    packetS(count)=fgetl(serialPort);
    
   
    
    times(count)=t;
    count=count+1;
   
    
    
     
    %--------------------Stage 1:correction position----------------------%

    
    %[qk1, Pk1]= Stage1(acc,qk,Pk);
    
    %[yaw,pitch,roll]=quat2angle(qk1');
    %yaw=yaw*180/pi;
    %pitch=pitch*180/pi;
    %roll=-roll*180/pi;
    
        
    
    %Feedbacks loop 
    % p_qk=qk1;
    % p_Pk=Pk1;
    
    % T=toc;

    
    
    
    %-------------------------------Display data--------------------------%
    % Get current time
     t =  datetime('now') - startTime;
    % Add points to animation
    % addpoints(rollLine,datenum(t),roll)
    %addpoints(pitchLine,datenum(t),pitch)
    % addpoints(rollM,datenum(t),eulerMicro(3))
    %addpoints(pitchM,datenum(t),eulerMicro(2))
    
    
        
    
   

    
    % Update axes
    %ax.XLim =  datenum([t-seconds(15) t]);
    %datetick('x','keeplimits')
    %drawnow
    
     
    % Check stop condition
     if(seconds(t)>10)
         stop=true;
     end
    
end






%% Close serial connection

fclose(serialPort);
clc;




end

