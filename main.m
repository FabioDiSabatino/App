function [x,y] = main()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%% Init serial port

%Custom some properties before open the serial communication
serialPort=initSerial("COM3",9600,64);

%Open serial port using properties setted by initSerial function
fopen(serialPort);

%% Acquire and display live data

figure
title('Graph of Accellerometer data acquired from LSM9DS1 MEMS');

AccX= animatedline(0,0,'Color','r');
AccY= animatedline(0,0,'Color','b');
AccZ= animatedline(0,0,'Color','g');
ax = gca;
ax.YGrid = 'on';
ax.YLim = [-2 2];
xlabel('time elapsed (s)');
ylabel('Accelleration (G)');

legend('X','Y','Z');

stop = false;
startTime = datetime('now');
while ~stop
    %Read data from buffer till the end of line 
    out= fgetl(serialPort);
    
    %Split Accelerometer and gyroscope data
    [x,y]=splitLcData(out);   
    
    % Get current time
    t =  datetime('now') - startTime;
    % Add points to animation
    addpoints(AccX,datenum(t),x(1))
    addpoints(AccY,datenum(t),x(2))
    addpoints(AccZ,datenum(t),x(3))

    
    % Update axes
    ax.XLim = datenum([t-seconds(15) t]);
    datetick('x','keeplimits')
    drawnow
    
    % Check stop condition
    if(seconds(t)>40)
        stop=true;
    end
end


%% Acquire and compute data

stop = false;
startTime = datetime('now');
while ~stop
    %Read data from buffer till the end of line 
    out= fgetl(serialPort);
    
    %Split Accelerometer and gyroscope data
    [x,y]=splitLcData(out);   
    
    % Get current time
    t =  datetime('now') - startTime;
    
    % Compute data
    
    
    % Check stop condition
    if(seconds(t)>40)
        stop=true;
    end
end


%% Close serial connection
fclose(serialPort);
delete(serialPort);
clear serialPort;




end

