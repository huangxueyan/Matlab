%% ��ȡƵ��+ʱ��txt����
fileID = fopen('500hzsqrt-���󲻻��-Ƶ��-sin+sqr+��ͨ.txt', 'r');
% ����ǰ���У�������һ�����ڣ��Լ�Сʱ��minute 
acell = textscan(fileID,'%*s %*f:%*f:%f %f ','HeaderLines',5); %ʱ������
%��ȡ�����Ƶ�����ݣ����´�file�ɽ��Ŷ���ȥ��
bcell= textscan(fileID,'%f %f','HeaderLines',2);
fclose(fileID);%ûclose֮ǰ�ǽ�����һ�δ�������������ȥ��

%���ݵľ��廮��
time1=acell{1};%��¼ch0��ʱ������
amplitude1=acell{2};%��¼ch0�ķ�ֵ����
frequency1=bcell{1};%Ƶ��x����
db_amplitude1=bcell{2};%Ƶ��y����

%%��ͼ����
set(gcf,'Position',[10 100 660 620]);%���ô��ڵĴ�С��λ��
%��Ƶ��ͼ
subplot(3,1,[1 2]);
plot(frequency1,db_amplitude1,'black')%һ��channel��Ƶ��ͼ
title("span5000-pulse-100Hz")
legend("frequency domain")
xlabel("frequency/Hz")
ylabel("db")

%��ʱ��ͼ
subplot(3,1,3);
plot(time1,amplitude1)%һ��channel��ʱ��ͼ
% title("pulse-1000Hz-duty-50")
% legend("time domain")
xlabel("time/ms")
ylabel("amplitude/V")
%% ��fft��ͨ��log��ʱ���ź����Ƶ���Σ�����NI������ȷ��
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

%��ʱ��ͼ
subplot(3,1,3);
plot(time1,amplitude1)%һ��channel��ʱ��ͼ
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

%% ���ڴ�log��Ѱ��, Ŀ�������Ƶ����Ӧ
figure
findpeaks(db_amplitude1,frequency1,'MinPeakDistance',150)
[peak1,location1] =findpeaks(db_amplitude1,frequency1,'MinPeakDistance',150)

figure %���߻�ͼ
plot(frequency1,db_amplitude1,location1,peak1,'o')
title("extract peak value")
% axis([33.332,33.355 , -3 3])
legend("frequency domain")
xlabel("frequency/Hz")
ylabel("db")
%�ҳ���Щ��ֵ�����������index
index=1:1:length(peak1)
for i = 1:1:length(location1)
    index(i)=find(abs(frequency1-location1(i))<1)
end

%% ��ȡ��ͨ�źŵ�Ƶ��
figure
fileID = fopen('180-��ͨ�ź�.txt', 'r');
% ����ǰ���У�������һ�����ڣ��Լ�Сʱ��minute 
acell = textscan(fileID,'%*s %*f:%*f:%f %f ','HeaderLines',5); %ʱ������
%��ȡ�����Ƶ�����ݣ����´�file�ɽ��Ŷ���ȥ��
bcell= textscan(fileID,'%f %f','HeaderLines',2);
fclose(fileID);%ûclose֮ǰ�ǽ�����һ�δ�������������ȥ��

%���ݵľ��廮��
time1=acell{1};%��¼ch0��ʱ������
amplitude1=acell{2};%��¼ch0�ķ�ֵ����
frequency2=bcell{1};
db_amplitude2=bcell{2};

%%��ͼ����
set(gcf,'Position',[10 100 660 620]);%���ô��ڵĴ�С��λ��
%��Ƶ��ͼ
subplot(3,1,[1 2]);
plot(frequency2,db_amplitude2,'black')%һ��channel��Ƶ��ͼ
title("span1000-pulse-100Hz")
legend("frequency domain")
xlabel("frequency/Hz")
ylabel("db")

%��ʱ��ͼ
subplot(3,1,3);
plot(time1,amplitude1)%һ��channel��ʱ��ͼ
% title("pulse-1000Hz-duty-50")
% legend("time domain")
xlabel("time/ms")
ylabel("amplitude/V")

%% ��ԭʼ�źŷ�ֵΪ׼�����ͨ�˲���ķ�ֵ��
figure
plot(frequency2,db_amplitude2,frequency2(index),db_amplitude2(index),'o')
title("extract peak value")
legend("frequency domain")
xlabel("frequency/Hz")
ylabel("db")

%%  ��������ֵ����÷�Ƶ��Ӧ am2/am1��λΪdb
figure
plot(frequency1(index),db_amplitude2(index)-db_amplitude1(index),...
	frequency1(index),db_amplitude2(index)-db_amplitude1(index),'o')
title("low-Pass-response")
legend("frequency domain-180")
xlabel("frequency/Hz")
ylabel("db")

%% �����ϵĻ�����г����ֵ����������Ҫ�õ���
%����ʵ�����е�ͨ�źŵĸ���Ҷ������ԭʼ�źŵĸ���Ҷ���Ǹɴ�ֱ��������ɡ�
%Ƶ��ķ�������Ҷ�ֽ�--��������Ӧ--�����Ѿ����B����
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

%% ����ȡʱ��txt����
fileID = fopen('500hzsqrt-ƫ�󲻻��-ʱ��.txt', 'r');
% ����ǰ���У�������һ�����ڣ��Լ�Сʱ��minute
acell = textscan(fileID,'%*s %*f:%*f:%f %f %*s %*f:%*f:%f %f ','HeaderLines',5); 
fclose(fileID);
%���ݵľ��廮��
time1=acell{1};%��¼ch0��ʱ������
amplitude1=acell{2};%��¼ch0�ķ�ֵ����
time2=acell{3};%��¼ch1��ʱ������
amplitude2=acell{4};%��¼ch1�ķ�ֵ����

%% ʱ��ͼ����
plot(time1,amplitude1,time2,amplitude2)%����channel��ʱ��ͼ
title("lowpass-500Hz-leftside-timedomain")
% axis([33.332,33.355 , -3 3])
legend("output","origin")
xlabel("time/ms")
ylabel("amplitude/V")

%% ���һ�� ��matlab��һ�����ݵ�Ƶ�ס�
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

%��ʱ��ͼ
subplot(3,1,3);
plot(time1,amplitude2)%һ��channel��ʱ��ͼ
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

%% excel��ȡ����
exceldata=xlsread('data2018917.xlsx','sheet1','A2:N30');
%% ͨ��excel���ݻ�ͼ
%ͨ����ͨ�˲��Ĺ�ʽ��ϣ�˳������ֹƵ�ʵ�
%��ֹƵ��ͳ�� 12x-245,34x-405,56x-805,78x-1266,910x-13340,1112x-610,,1314x-297
[sourceHz,response]=deal(exceldata(:,7),exceldata(:,8));
figure
response1=plot(sourceHz,response);%����Ƶ����Ӧͼ
hold on ;
title("��ͨ�˲���Ƶ����Ӧ")
% axis([33.332,33.355 , -3 3])
xlabel("frequency/Hz")
ylabel("amplitude/V")
scatter(deal(exceldata(:,7)),deal(exceldata(:,8)),30,'o')
%ͨ��0.707�ĵ��ҳ�����Ƶ�ʡ�
% linex=1:1:2000
% stopline=plot(linex,liney,'r')

%��ӱ�ע
% text(256,751,'\leftarrow sin(\pi)')
endpointx=[1266];
endpointy=[0:10:750];
text(endpointx(1)+30,720,'��ֹ��')
text(endpointx(1)+30,680,'X=1266')
plot(ones(1,length(endpointy))*endpointx(1),endpointy,'black--')
scatter(endpointx(1),751,40,'blueo','filled')
legend(response1,'180��')
%��ӽ������x����label
% xticks([245])
% xticklabels({'x = 245'})

%% excel���ݵ����,���������ͨ�˲����Ǵ�ͳ�Ĵ�ͳ���˲��������Ч���ܲ�
% f = fittype('a*1/(1+w/w0)','independent','w','coefficients',{'a','w0'})
% func = fit(sourceHz,response,f)
% x=50:1:600;
% y=func(x);
% fitline=plot(x,y,'r')
% legend([response1,fitline],"��ͷָ������","�������")
%% ����Ϊexcel������plot
% response1=plot(deal(exceldata(:,1)),deal(exceldata(:,2)));%����Ƶ����Ӧͼ
% hold on ;
% response2=plot(deal(exceldata(:,3)),deal(exceldata(:,4)));%����Ƶ����Ӧͼ
% response3=plot(deal(exceldata(:,5)),deal(exceldata(:,6)));%����Ƶ����Ӧͼ
% response4=plot(deal(exceldata(:,7)),deal(exceldata(:,8)));%����Ƶ����Ӧͼ
% response5=plot(deal(exceldata(:,9)),deal(exceldata(:,10)));%����Ƶ����Ӧͼ
% response6=plot(deal(exceldata(:,11)),deal(exceldata(:,12)));%����Ƶ����Ӧͼ
% 
% scatter(deal(exceldata(:,1)),deal(exceldata(:,2)),30,'o')
% scatter(deal(exceldata(:,3)),deal(exceldata(:,4)),30,'o')
% scatter(deal(exceldata(:,5)),deal(exceldata(:,6)),30,'o')
% scatter(deal(exceldata(:,7)),deal(exceldata(:,8)),30,'o')
% scatter(deal(exceldata(:,9)),deal(exceldata(:,10)),30,'o')
% scatter(deal(exceldata(:,11)),deal(exceldata(:,12)),30,'o')
%������legend
% totalresponse=[response1 response2 response3 response4 response5 response6 ];
% legend(response5,"��ͷָ������")

%% ʱ���������ƫ�õ���� ��˫�ߴ�ת���ߴ�
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

%�����ı��ʽ
function y = sqr(x)
y=x
end