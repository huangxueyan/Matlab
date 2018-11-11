%% 化简z式子
a1=[1 1.60 0.8]; 
b1=[0.8 1.6 1];
a2=[1 -1.60 0.902]; 
b2=[1 2 1];
w=[0:0.1:2*pi];
h1=freqz(b1,a1,w) %频率响应
freqz(b1,a1,w) %频率响应和相频响应
fvtool(b1,a1,'polezero')
[b1,a1] = eqtflength(b1,a1);
[z1,p1,k1] = tf2zp(b1,a1)
[b2,a2] = eqtflength(b2,a2);
[z2,p2,k2] = tf2zp(b2,a2)
z,p,k
%% 
figure
%画出极点 零点
hold on 
plot(p1,'o','MarkerFaceColor','b')%极点
plot(p2,'o','MarkerFaceColor','g')%极点
text(real(p2)+0.1,imag(p2)*1.1,'new')
text(real(p1)+0.1,imag(p1),'old')
plot(complex(z1),'o','MarkerFaceColor','r')
plot(complex(z2),'o','MarkerFaceColor','r')
text(real(z1)+0.1,imag(z)-0.1,'zero')
xlim([-1.2 1.2])
ylim([-1.2 1.2])
grid on;
%画出圆虚线
alpha=0:pi/25:2*pi;%角度[0,2*pi]
x=cos(alpha);
y=sin(alpha);
plot(x,y,'b --')
plot(linspace(-1.2,1.2,10),zeros(10),'b --')
plot(zeros(10),linspace(-1.2,1.2,10),'b--')

xlabel('real')
ylabel('image')
%% 实测频率响应
% excel读取数据
exceldata=xlsread('exp4.xlsx','sheet1','A2:R21');
sourceHz=[];
response=[];
i=0;
for x = 1:2:17
i=i+1
[sourceHz(i,:),response(i,:)]=deal(exceldata(:,x),exceldata(:,x+1));
end

close all;
i=9 %不同图改这边
figure(i)
plot(sourceHz(i,:),20*log10(2*response(i,:)),'o')
hold on 
label1=plot(sourceHz(i,:),20*log10(2*response(i,:)))
xlabel('frequency(Hz)')
ylabel('amplitude(db)')
%理论值 改这边
a=[1 0 -0.8]; 
b=[0.8 0 1];
[h,w] = freqz(b,a,1000,fs);
label2=plot(w,20*log10(abs(h)))
xlim([0,5000])
legend([label1,label2],'实测','理论')