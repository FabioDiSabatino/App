function  main()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%----------------------Init serial port------------------------------%

%Custom some properties before open the serial communication
serialPort=initSerial("COM3",9600,64);

%--------------------------------------------------------------------%

%----------------------Init constants--------------------------------%

figure
title('Graph of Accellerometer data acquired from LSM9DS1 MEMS');

AccX= animatedline(0,0,'Color','r');
AccY= animatedline(0,0,'Color','b');
AccZ= animatedline(0,0,'Color','g');
ax = gca;
ax.YGrid = 'on';
ax.YLim = [-2 2];
xlabel('time elapsed (T)');
ylabel('Accelleration (m/s^2)');

legend('X','Y','Z');

stop = false;
startTime = datetime('now');
%Discrete time variable
T=0;

qk=[0 0 0 0].';

p_qk=0;


Pk=eye(4);

p_Pk=eye(4);


while ~stop
    %-----------------------------Read data sensor------------------------%
    [acc,gyro,eulerMicro]=read(serialPort);
    
    %--------------------Stage 0:Angular position estimation -------------%
    
    [qk,Pk] = Stage0(gyro,p_qk,p_Pk,T);
    
    %--------------------Stage 1:correction position----------------------%

    
    [qk1, Pk1]= Stage1(acc,qk,Pk);
    
    
    
    
    
    
    
    
    
    
    
    %-------------------------------Display data--------------------------%
    % Get current time
    t =  datetime('now') - startTime;
    % Add points to animation
    addpoints(AccX,T,acc(1))
    addpoints(AccY,T,acc(2))
    addpoints(AccZ,T,acc(3))

    
    % Update axes
    ax.XLim = datenum([t-seconds(15) t]);
    datetick('x','keeplimits')
    drawnow
    
    % Check stop condition
    if(seconds(t)>40)
        stop=true;
    end
end



% Close serial connection
fclose(serialPort);
delete(serialPort);
clear serialPort;




end

