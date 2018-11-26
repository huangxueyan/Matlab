%% matlab 2piͼ zplaneͼ
clear all ,clc,close all
zplane([1,-1.3,0.9025])
title("�㼫��ͼ"),grid
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
title("��Ƶ��Ӧ")
%% ʵ��
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
title("ʵ���Ƶ��Ӧb0=1 b1=-1.3 b2=0.874")
ylabel("response(V)")
xlabel("frequency(rad/s)")
%% matlab ����Ƶ�ʷ�Ƶ����
figure
fs=20000 %����;
n=0;
%a�ĵ�һ��1��ʾyn��������ʾy��n-1�����������1�Ǳ����
a=[1 -1.6 0.902]; 
b=[1 -2 1];
% y=filter(b,a,sin(2*pi*1000*[1:100]))
[h,w] = freqz(b,a,30,fs);
freqz(b,a,30,fs);
subplot(2,1,1)
figure
stem(w,abs(h))
hold on 
% index=find(abs(h)==min(abs(h))); %��ע��͵�
% stem(w(index),abs(h(index)),'filled')
% text(w(index)-300,abs(h(index)+0.7),"�ݲ�Ƶ��1270Hz")
title("matlab���� ���һ")
ylabel("response(V)")
xlabel("frequency(Hz)")
%% �ⷽ��
% ans=solve(x^2 - 1.2*x + 0.902 == 0, x)
% ans=eval(ans) %����
% angle(ans(1))/pi
% fre_xianbo=0.255*5000%���Ƕ�ת���ݲ�Ƶ��

%�ȼ���
ans=roots([1 -1.86 0.92])
%% ���Ҳ�������ͨ
t=0:1:1000;
a=sin(2*pi*500/10000*t);
b=sin(2*pi*1300/10000*t);
c=a+b;
y=filter([1 -1.3 0.902],[1],c);
stem(t(1:100),y(1:100))
hold on;
stem(t(1:100),c(1:100))
%% Ƶ��fft
fs=10000;%����Ƶ��
N=length(t); %���ݵ����
Y=fft(y,N);%��ɢ����Ҷ�任
p2 = abs(Y/N);
p1 = p2(1:N/2+1);
p1(2:end-1) = 2*p1(2:end-1);
f = fs*(0:(N/2))/N;
figure
plot(f,p1)
title("FFT-�ݲ�����ź�")
xlabel("frequency(Hz)")
ylabel("amplitude(V)")
%%
plot(t(1:100),y(1:100),'o');
hold on 
plot(t(1:100),c(1:100),'o')
plot(t(1:100),y(1:100),'b')
plot(t(1:100),c(1:100),'r')
legend("output","input")
title("matlab����ʱ��ͼ")
%% ����zʽ��
a1=[1 1.60 0.8]; 
b1=[0.8 1.6 1];
a2=[1 -1.60 0.902]; 
b2=[1 2 1];
w=[0:0.1:2*pi];
h1=freqz(b1,a1,w) %Ƶ����Ӧ
freqz(b1,a1,w) %Ƶ����Ӧ����Ƶ��Ӧ
fvtool(b1,a1,'polezero')
[b1,a1] = eqtflength(b1,a1);
[z1,p1,k1] = tf2zp(b1,a1)
[b2,a2] = eqtflength(b2,a2);
[z2,p2,k2] = tf2zp(b2,a2)
z,p,k
%% 
figure
%�������� ���
hold on 
plot(p1,'o','MarkerFaceColor','b')%����
plot(p2,'o','MarkerFaceColor','g')%����
text(real(p2)+0.1,imag(p2)*1.1,'new')
text(real(p1)+0.1,imag(p1),'old')
plot(complex(z1),'o','MarkerFaceColor','r')
plot(complex(z2),'o','MarkerFaceColor','r')
text(real(z1)+0.1,imag(z)-0.1,'zero')
xlim([-1.2 1.2])
ylim([-1.2 1.2])
grid on;
%����Բ����
alpha=0:pi/25:2*pi;%�Ƕ�[0,2*pi]
x=cos(alpha);
y=sin(alpha);
plot(x,y,'b --')
plot(linspace(-1.2,1.2,10),zeros(10),'b --')
plot(zeros(10),linspace(-1.2,1.2,10),'b--')

xlabel('real')
ylabel('image')
%% ʵ��Ƶ����Ӧ
% excel��ȡ����
exceldata=xlsread('exp4.xlsx','sheet1','A2:R21');
sourceHz=[];
response=[];
i=0;
for x = 1:2:17
i=i+1
[sourceHz(i,:),response(i,:)]=deal(exceldata(:,x),exceldata(:,x+1));
end

close all;
i=9 %��ͬͼ�����
figure(i)
plot(sourceHz(i,:),20*log10(2*response(i,:)),'o')
hold on 
label1=plot(sourceHz(i,:),20*log10(2*response(i,:)))
xlabel('frequency(Hz)')
ylabel('amplitude(db)')
%����ֵ �����
a=[1 0 -0.8]; 
b=[0.8 0 1];
[h,w] = freqz(b,a,1000,fs);
label2=plot(w,20*log10(abs(h)))
xlim([0,5000])
legend([label1,label2],'ʵ��','����')