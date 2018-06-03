function  main()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Init serial port
clear all;
clc;
%Custom some properties before open the serial communication
serialPort=initSerial("COM3",9600,128);


%% Test packets lost

clearvars -except serialPort;



stop = false;

startTime = datetime('now');

times=zeros(1,10000);
packetsID=zeros(1,10000);
packetS=strings(1,10000);
count=1;
avgTime=0;
lostn=0;
clc;
flushinput(serialPort)
tic
while ~stop
    
    
    t=toc;
    
    if(serialPort.TransferStatus ~= 'read')
    readasync(serialPort);
    packetS(count)=fgetl(serialPort);
    times(count)=t;
    count=count+1;
    end
    
    
   
    
   % Get current time
     t =  datetime('now') - startTime;
         
    % Check stop condition
     if(seconds(t)>60)
         stop=true;
     end
   
end

count = count-1;
for c=2:count
    
    avgTime=avgTime+times(c);
   
    id=strsplit(packetS(c),'|');
    packetsID(c)=str2double(id(1));

end

lost=0;


f = figure;





p = uipanel('Parent',f,'BorderType','none'); 
p.Title = 'Analisi dei pacchetti ricevuti'; 
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';



ax1=subplot(2,1,1,'Parent',p);
packetIDline= animatedline(0,0,'Color','b','LineStyle',':');

title('ID pacchetti catturati');
ax1.YGrid = 'on';
ax1.YLim = [0 count];
ax1.XLim =  [times(2) times(count)];
xlabel('tempo (s)');
ylabel('ID');

for c=2:count
    addpoints(packetIDline,times(c),packetsID(c));
end

ax2=subplot(2,1,2,'Parent',p);
packetLostline= animatedline(0,0,'Color','r');

title('Pacchetti persi');
ax2.YGrid = 'on';
ax2.YLim = [0 2000];
ax2.XLim =  [1 count];
xlabel('Iterazione N°');
ylabel('ID(i) - ID(i+1)');

for c=2:count-1
    
    if(packetsID(c)+1 ~=  packetsID(c+1))
       
        lost= packetsID(c+1)-packetsID(c);
        lostn=lostn+1;
        
    else
        lost=0;
    end
    
    
    addpoints(packetLostline,c,lost);
end
i=1:count;
t=table(i',times(1,1:count)',packetsID(1,1:count)');


%% Close serial connection

fclose(serialPort);
clc;




end

