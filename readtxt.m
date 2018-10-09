%% 读取频域+时域txt数据
fileID = fopen('500hzsqrt-最左不混叠-频域-sin+sqr+低通.txt', 'r');
% 跳过前五行，跳过第一个日期，以及小时和minute 
acell = textscan(fileID,'%*s %*f:%*f:%f %f ','HeaderLines',5); %时域数据
%读取后面的频域数据，重新打开file可接着读下去。
bcell= textscan(fileID,'%f %f','HeaderLines',2);
fclose(fileID);%没close之前是接着上一次打开最后的行数读下去的

%数据的具体划分
time1=acell{1};%记录ch0的时间数据
amplitude1=acell{2};%记录ch0的幅值数据
frequency1=bcell{1};%频域x坐标
db_amplitude1=bcell{2};%频域y坐标

%%画图区域
set(gcf,'Position',[10 100 660 620]);%设置窗口的大小和位置
%画频域图
subplot(3,1,[1 2]);
plot(frequency1,db_amplitude1,'black')%一个channel的频域图
title("span5000-pulse-100Hz")
legend("frequency domain")
xlabel("frequency/Hz")
ylabel("db")

%画时域图
subplot(3,1,3);
plot(time1,amplitude1)%一个channel的时域图
% title("pulse-1000Hz-duty-50")
% legend("time domain")
xlabel("time/ms")
ylabel("amplitude/V")
%% 用fft，通过log的时域信号求出频域波形，看看NI仪器正确性
figure;
fs=10000;
N=length(amplitude1);
n=0:N-1;
Y=fft(amplitude1,N);
YY=20*log10(abs(Y)/N);
f=n*fs/N;

subplot(3,1,[1 2]);
plot(f(1:N/2),YY(1:N/2)) 
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('(db)')

%画时域图
subplot(3,1,3);
plot(time1,amplitude1)%一个channel的时域图
% title("pulse-1000Hz-duty-50")
% legend("time domain")
xlabel("time/ms")
ylabel("amplitude/V")

figure;
IY=ifft(Y);
plot(time1,amplitude1)
title("IFFT")
xlabel("time/ms")
ylabel("amplitude/V")

%% 现在从log中寻峰, 目的是求出频率响应
figure
findpeaks(db_amplitude1,frequency1,'MinPeakDistance',150)
[peak1,location1] =findpeaks(db_amplitude1,frequency1,'MinPeakDistance',150)

figure %曲线画图
plot(frequency1,db_amplitude1,location1,peak1,'o')
title("extract peak value")
% axis([33.332,33.355 , -3 3])
legend("frequency domain")
xlabel("frequency/Hz")
ylabel("db")
%找出这些峰值在数组里面的index
index=1:1:length(peak1)
for i = 1:1:length(location1)
    index(i)=find(abs(frequency1-location1(i))<1)
end

%% 读取低通信号的频域
figure
fileID = fopen('180-低通信号.txt', 'r');
% 跳过前五行，跳过第一个日期，以及小时和minute 
acell = textscan(fileID,'%*s %*f:%*f:%f %f ','HeaderLines',5); %时域数据
%读取后面的频域数据，重新打开file可接着读下去。
bcell= textscan(fileID,'%f %f','HeaderLines',2);
fclose(fileID);%没close之前是接着上一次打开最后的行数读下去的

%数据的具体划分
time1=acell{1};%记录ch0的时间数据
amplitude1=acell{2};%记录ch0的幅值数据
frequency2=bcell{1};
db_amplitude2=bcell{2};

%%画图区域
set(gcf,'Position',[10 100 660 620]);%设置窗口的大小和位置
%画频域图
subplot(3,1,[1 2]);
plot(frequency2,db_amplitude2,'black')%一个channel的频域图
title("span1000-pulse-100Hz")
legend("frequency domain")
xlabel("frequency/Hz")
ylabel("db")

%画时域图
subplot(3,1,3);
plot(time1,amplitude1)%一个channel的时域图
% title("pulse-1000Hz-duty-50")
% legend("time domain")
xlabel("time/ms")
ylabel("amplitude/V")

%% 以原始信号峰值为准求出低通滤波后的峰值。
figure
plot(frequency2,db_amplitude2,frequency2(index),db_amplitude2(index),'o')
title("extract peak value")
legend("frequency domain")
xlabel("frequency/Hz")
ylabel("db")

%%  将两个峰值相减得幅频响应 am2/am1单位为db
figure
plot(frequency1(index),db_amplitude2(index)-db_amplitude1(index),...
	frequency1(index),db_amplitude2(index)-db_amplitude1(index),'o')
title("low-Pass-response")
legend("frequency domain-180")
xlabel("frequency/Hz")
ylabel("db")

%% 理论上的基波和谐波幅值，但好像不需要用到。
%但其实不仅有低通信号的傅里叶，还有原始信号的傅里叶，那干脆直接相减即可。
%频域的方波傅里叶分解--求脉冲响应--现在已经求出B分量
figure()
t=linspace(0,10,1000);
y=square(t,50);
plot(t,y);
hold on;
ylim([-2.5,2.5])
E=1;
n=9;
i=1:2:n
b(i)=4*E./i/pi
fourier_sin=0
for j = 1:1:n
fourier_sin=fourier_sin+b(j)*sin(j*t)
end 
stem(b)
plot(t,fourier_sin)

%% 仅读取时域txt数据
fileID = fopen('500hzsqrt-偏左不混叠-时域.txt', 'r');
% 跳过前五行，跳过第一个日期，以及小时和minute
acell = textscan(fileID,'%*s %*f:%*f:%f %f %*s %*f:%*f:%f %f ','HeaderLines',5); 
fclose(fileID);
%数据的具体划分
time1=acell{1};%记录ch0的时间数据
amplitude1=acell{2};%记录ch0的幅值数据
time2=acell{3};%记录ch1的时间数据
amplitude2=acell{4};%记录ch1的幅值数据

%% 时域画图区域
plot(time1,amplitude1,time2,amplitude2)%两个channel的时域图
title("lowpass-500Hz-leftside-timedomain")
% axis([33.332,33.355 , -3 3])
legend("output","origin")
xlabel("time/ms")
ylabel("amplitude/V")

%% 最后一问 用matlab求一堆数据的频谱。
figure;
% fs=125000;
% L=length(amplitude2);
% Y = fft(amplitude2);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f=5000*(0:(L/2))/L;
fs=125000;
N=length(amplitude2);
n=0:N-1;
Y=fft(amplitude2,N);
YY=20*log10(abs(Y)/N);
f=n*fs/N;

subplot(3,1,[1 2]);
plot(f(1:N/40),YY(1:N/40)) 
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('(db)')

%画时域图
subplot(3,1,3);
plot(time1,amplitude2)%一个channel的时域图
% title("pulse-1000Hz-duty-50")
% legend("time domain")
xlabel("time/ms")
ylabel("amplitude/V")

figure;
IY=ifft(Y)
plot(time1,amplitude2,'r')
title("origin")
xlabel("time/ms")
ylabel("amplitude/V")

%% excel读取数据
exceldata=xlsread('data2018917.xlsx','sheet1','A2:N30');
%% 通过excel数据画图
%通过低通滤波的公式拟合，顺便标出截止频率点
%截止频率统计 12x-245,34x-405,56x-805,78x-1266,910x-13340,1112x-610,,1314x-297
[sourceHz,response]=deal(exceldata(:,7),exceldata(:,8));
figure
response1=plot(sourceHz,response);%画出频率响应图
hold on ;
title("低通滤波器频率响应")
% axis([33.332,33.355 , -3 3])
xlabel("frequency/Hz")
ylabel("amplitude/V")
scatter(deal(exceldata(:,7)),deal(exceldata(:,8)),30,'o')
%通过0.707的点找出截至频率。
% linex=1:1:2000
% stopline=plot(linex,liney,'r')

%添加标注
% text(256,751,'\leftarrow sin(\pi)')
endpointx=[1266];
endpointy=[0:10:750];
text(endpointx(1)+30,720,'截止点')
text(endpointx(1)+30,680,'X=1266')
plot(ones(1,length(endpointy))*endpointx(1),endpointy,'black--')
scatter(endpointx(1),751,40,'blueo','filled')
legend(response1,'180°')
%添加截至点的x坐标label
% xticks([245])
% xticklabels({'x = 245'})

%% excel数据的拟合,发现这个低通滤波不是传统的传统的滤波，所拟合效果很差
% f = fittype('a*1/(1+w/w0)','independent','w','coefficients',{'a','w0'})
% func = fit(sourceHz,response,f)
% x=50:1:600;
% y=func(x);
% fitline=plot(x,y,'r')
% legend([response1,fitline],"箭头指向最左","拟合曲线")
%% 以下为excel多曲线plot
% response1=plot(deal(exceldata(:,1)),deal(exceldata(:,2)));%画出频率响应图
% hold on ;
% response2=plot(deal(exceldata(:,3)),deal(exceldata(:,4)));%画出频率响应图
% response3=plot(deal(exceldata(:,5)),deal(exceldata(:,6)));%画出频率响应图
% response4=plot(deal(exceldata(:,7)),deal(exceldata(:,8)));%画出频率响应图
% response5=plot(deal(exceldata(:,9)),deal(exceldata(:,10)));%画出频率响应图
% response6=plot(deal(exceldata(:,11)),deal(exceldata(:,12)));%画出频率响应图
% 
% scatter(deal(exceldata(:,1)),deal(exceldata(:,2)),30,'o')
% scatter(deal(exceldata(:,3)),deal(exceldata(:,4)),30,'o')
% scatter(deal(exceldata(:,5)),deal(exceldata(:,6)),30,'o')
% scatter(deal(exceldata(:,7)),deal(exceldata(:,8)),30,'o')
% scatter(deal(exceldata(:,9)),deal(exceldata(:,10)),30,'o')
% scatter(deal(exceldata(:,11)),deal(exceldata(:,12)),30,'o')
%最后添加legend
% totalresponse=[response1 response2 response3 response4 response5 response6 ];
% legend(response5,"箭头指向最右")

%% 时域忘记添加偏置的情况 从双边带转单边带
% for i =1:length(amplitude2)
%     if amplitude1(i)>0
%         if amplitude2(i)<0
%             amplitude2(i)=0+random('normal',0,0.01,1);
%         end
%     else
%          if amplitude2(i)>0
%             amplitude2(i)=0+random('normal',0,0.01,1);
%          end
%     end
% end

%方波的表达式
function y = sqr(x)
y=x
end