%% matlab 2pi图 zplane图
clear all ,clc,close all
zplane([1,-1.3,0.9025])
title("零极点图"),grid
text(0.95*cos(0.260*pi)+0.1,0.95*sin(0.260*pi),"Z1")
text(0.95*cos(-0.260*pi)+0.1,0.95*sin(-0.260*pi),"Z2")
z1=0.95*exp(i*0.260*pi);
z2=0.95*exp(-i*0.260*pi);
n=0
for w=0:0.1:2*pi
	n=n+1;
	H(n)=abs((exp(i*w)-z1)*(exp(i*w)-z2));
end
figure()
stem([0:n-1]*0.1,H)
xticks([0 pi/2 pi 3*pi/2 2*pi])
xticklabels({'0','\pi/2', '\pi','3\pi/2', '2\pi'})
xlabel("frequency(rad/s)")
ylabel("response(V)")
title("幅频响应")
%% 实测
fre1=[300	500	700	900	1100	1200	1280	1400	1700	2000	2200	2500	3000	4000];
fre2=[300	500	700	900	1000	1100	1200	1400	1700	2000	2500	3000];
fre3=[300	400	500	600	700	900	1000	1200	1270	1300	1500	1700	2000	2300	2600	3000];
res1=[1.17	1.05	0.877	0.64	0.38	0.256	0.14	0.196	0.706	1.3	1.7	2.368	3.18	0.6504];
res2=[0.78	0.66	0.49	0.27	0.17	0.127	0.22	0.54	1.08	1.66	2.6	3.5];
res3=[1.12	1.069	0.5	0.92	0.83	0.61	0.49	0.25	0.166	0.176	0.39	0.75	1.32	1.91	2.49	3.18];
figure
stem(fre3,res3)
hold on 
plot(fre3,res3,'r')
hold off
title("实测幅频响应b0=1 b1=-1.3 b2=0.874")
ylabel("response(V)")
xlabel("frequency(rad/s)")
%% matlab 采样幅频特性
figure
z1=0.95*exp(i*0.260*pi);
z2=0.95*exp(-i*0.260*pi);

fs=10000 %采样;
n=0;
a=[1 ];
b=[1 -1.3 0.9];
% y=filter(b,a,sin(2*pi*1000*[1:100]))
[h,w] = freqz(b,a,30,fs);
stem(w,abs(h))
hold on 
index=find(abs(h)==min(abs(h)));
stem(w(index),abs(h(index)),'filled')
text(w(index)-300,abs(h(index)+0.7),"陷波频率1270Hz")
title("matlab仿真 b2=0.874")
ylabel("response(V)")
xlabel("frequency(Hz)")
%% 解方程
ans=solve(x^2 - 1.2*x + 0.902 == 0, x)
ans=eval(ans) %化简
angle(ans(1))/pi
fre_xianbo=0.255*5000%跟角度转换陷波频率
%% 正弦波经过低通
t=0:1:1000;
a=sin(2*pi*500/10000*t);
b=sin(2*pi*1300/10000*t);
c=a+b;
y=filter([1 -1.3 0.902],[1],c);
stem(t(1:100),y(1:100))
hold on;
stem(t(1:100),c(1:100))
%% 频谱fft
fs=10000;%采样频率
N=length(t); %数据点个数
Y=fft(y,N);%离散傅里叶变换
p2 = abs(Y/N);
p1 = p2(1:N/2+1);
p1(2:end-1) = 2*p1(2:end-1);
f = fs*(0:(N/2))/N;
figure
plot(f,p1)
title("FFT-陷波输出信号")
xlabel("frequency(Hz)")
ylabel("amplitude(V)")