%% 读取频域+时域txt数据
fileID = fopen('实验四170度频率响应in，方波100Hz.txt', 'r');
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
title("100hz脉冲信号")
legend("frequency domain")
xlabel("frequency/Hz")
ylabel("db")

%画时域图
subplot(3,1,3);
plot(time1,amplitude1)%一个channel的时域图
legend("time domain")
xlabel("time/ms")
ylabel("amplitude/V")
%% 用fft，通过log的时域信号求出频域波形，看看NI仪器正确性
figure;
fs=4000;%采样频率
N=length(amplitude1); %数据点个数
n=0:N-1;
Y=fft(amplitude1,N);%离散傅里叶变换
YY=20*log10(abs(Y)/N);%归一化幅值
f=n*fs/N;%频率刻度

subplot(3,1,[1 2]);
plot(f(1:N/2),YY(1:N/2)) 
title('Matlab-FFT-PCM')
xlabel('f (Hz)')
ylabel('(db)')
ylim([-70 0]);

%画时域图
subplot(3,1,3);
plot(time1,amplitude1)%一个channel的时域图
% title("pulse-1000Hz-duty-50")
% legend("time domain")
xlabel("time/ms")
ylabel("amplitude/V")

%逆傅里叶变换
% figure;
% IY=ifft(Y);
% plot(time1,amplitude1)
% title("IFFT")
% xlabel("time/ms")
% ylabel("amplitude/V")

%% 现在从log中寻峰, 目的是求出频率响应
%寻峰函数，输入时域和振幅序列，输出峰值坐标。
[peak1,location1] =findpeaks(db_amplitude1,frequency1, ... 
'MinPeakDistance',150,'MinPeakHeight',-30)
%画图
figure, subplot(3,1,[1 2]);
plot(frequency1,db_amplitude1,location1,peak1,'o')
title("extract peak value-input")
% axis([33.332,33.355 , -3 3])
legend("frequency domain")
xlabel("frequency/Hz")
ylabel("db")
%标记，自动标记多个峰值
for i =1:length(location1)
	text(location1(i),peak1(i)-3,int2str(location1(i))+"Hz")
end

subplot(3,1,3);
plot(time1,amplitude1)%一个channel的时域图
% title("pulse-1000Hz-duty-50")
% legend("time domain")
xlabel("time/ms")
ylabel("amplitude/V")

%找出这些峰值在数组里面的index
index=1:1:length(peak1)
for i = 1:1:length(location1)
    index(i)=find(abs(frequency1-location1(i))<1)
end
%画图：


%% 读取低通信号的频域
figure
fileID = fopen('实验四170度频率响应out，方波100Hz.txt', 'r');
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
title("low-Pass-response"),legend("幅频响应-170度")
xlabel("frequency/Hz"),ylabel("db")
xlim([0,1500])


%% 仅读取时域txt数据
fileID = fopen('最好波形时域蓝色为输出.txt', 'r');
% 跳过前五行，跳过第一个日期，以及小时和minute
acell = textscan(fileID,'%*s %*f:%*f:%f %f %*s %*f:%*f:%f %f ','HeaderLines',5); 
fclose(fileID);
%数据的具体划分
time1=acell{1};%记录ch0的时间数据
amplitude1=acell{2};%记录ch0的幅值数据
time2=acell{3};%记录ch1的时间数据
amplitude2=acell{4};%记录ch1的幅值数据

figure
plot(time1,amplitude1,time2,amplitude2)%两个channel的时域图
title("PCM解码信号时域波形图")
% axis([33.332,33.355 , -3 3])
legend("output","origin")
xlabel("time/ms")
ylabel("amplitude/V")

%% 画出二进制字的图形
figure(1) %新建一个图
DCY=[-2.5:0.5:2.5];%电压数据
DCX=[0,24,49,75,100,126,151,177,202,228,254];%10进制的编码
plot(DCX,DCY),hold on%画图数据连线
scatter(DCX,DCY,'ro')%画图，标注数据点
xlim([-5,260]),ylim([-3,3])%限定坐标轴的宽度
xticks([0,24,49,75,100,126,151,177,202,228,254])%确定标记点
%确定标记点的符号，16进制表达式
xticklabels({'0','18','31','4b','64','7e','97','b1','ca','e4','fe'});
xlabel("16进制"),ylabel("电压幅值")%xy坐标注释和标题
title("DC至二进制字图形")