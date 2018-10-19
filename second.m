%% ��ȡƵ��+ʱ��txt����
fileID = fopen('ʵ����170��Ƶ����Ӧin������100Hz.txt', 'r');
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
title("100hz�����ź�")
legend("frequency domain")
xlabel("frequency/Hz")
ylabel("db")

%��ʱ��ͼ
subplot(3,1,3);
plot(time1,amplitude1)%һ��channel��ʱ��ͼ
legend("time domain")
xlabel("time/ms")
ylabel("amplitude/V")
%% ��fft��ͨ��log��ʱ���ź����Ƶ���Σ�����NI������ȷ��
figure;
fs=4000;%����Ƶ��
N=length(amplitude1); %���ݵ����
n=0:N-1;
Y=fft(amplitude1,N);%��ɢ����Ҷ�任
YY=20*log10(abs(Y)/N);%��һ����ֵ
f=n*fs/N;%Ƶ�ʿ̶�

subplot(3,1,[1 2]);
plot(f(1:N/2),YY(1:N/2)) 
title('Matlab-FFT-PCM')
xlabel('f (Hz)')
ylabel('(db)')
ylim([-70 0]);

%��ʱ��ͼ
subplot(3,1,3);
plot(time1,amplitude1)%һ��channel��ʱ��ͼ
% title("pulse-1000Hz-duty-50")
% legend("time domain")
xlabel("time/ms")
ylabel("amplitude/V")

%�渵��Ҷ�任
% figure;
% IY=ifft(Y);
% plot(time1,amplitude1)
% title("IFFT")
% xlabel("time/ms")
% ylabel("amplitude/V")

%% ���ڴ�log��Ѱ��, Ŀ�������Ƶ����Ӧ
%Ѱ�庯��������ʱ���������У������ֵ���ꡣ
[peak1,location1] =findpeaks(db_amplitude1,frequency1, ... 
'MinPeakDistance',150,'MinPeakHeight',-30)
%��ͼ
figure, subplot(3,1,[1 2]);
plot(frequency1,db_amplitude1,location1,peak1,'o')
title("extract peak value-input")
% axis([33.332,33.355 , -3 3])
legend("frequency domain")
xlabel("frequency/Hz")
ylabel("db")
%��ǣ��Զ���Ƕ����ֵ
for i =1:length(location1)
	text(location1(i),peak1(i)-3,int2str(location1(i))+"Hz")
end

subplot(3,1,3);
plot(time1,amplitude1)%һ��channel��ʱ��ͼ
% title("pulse-1000Hz-duty-50")
% legend("time domain")
xlabel("time/ms")
ylabel("amplitude/V")

%�ҳ���Щ��ֵ�����������index
index=1:1:length(peak1)
for i = 1:1:length(location1)
    index(i)=find(abs(frequency1-location1(i))<1)
end
%��ͼ��


%% ��ȡ��ͨ�źŵ�Ƶ��
figure
fileID = fopen('ʵ����170��Ƶ����Ӧout������100Hz.txt', 'r');
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
title("low-Pass-response"),legend("��Ƶ��Ӧ-170��")
xlabel("frequency/Hz"),ylabel("db")
xlim([0,1500])


%% ����ȡʱ��txt����
fileID = fopen('��ò���ʱ����ɫΪ���.txt', 'r');
% ����ǰ���У�������һ�����ڣ��Լ�Сʱ��minute
acell = textscan(fileID,'%*s %*f:%*f:%f %f %*s %*f:%*f:%f %f ','HeaderLines',5); 
fclose(fileID);
%���ݵľ��廮��
time1=acell{1};%��¼ch0��ʱ������
amplitude1=acell{2};%��¼ch0�ķ�ֵ����
time2=acell{3};%��¼ch1��ʱ������
amplitude2=acell{4};%��¼ch1�ķ�ֵ����

figure
plot(time1,amplitude1,time2,amplitude2)%����channel��ʱ��ͼ
title("PCM�����ź�ʱ����ͼ")
% axis([33.332,33.355 , -3 3])
legend("output","origin")
xlabel("time/ms")
ylabel("amplitude/V")

%% �����������ֵ�ͼ��
figure(1) %�½�һ��ͼ
DCY=[-2.5:0.5:2.5];%��ѹ����
DCX=[0,24,49,75,100,126,151,177,202,228,254];%10���Ƶı���
plot(DCX,DCY),hold on%��ͼ��������
scatter(DCX,DCY,'ro')%��ͼ����ע���ݵ�
xlim([-5,260]),ylim([-3,3])%�޶�������Ŀ��
xticks([0,24,49,75,100,126,151,177,202,228,254])%ȷ����ǵ�
%ȷ����ǵ�ķ��ţ�16���Ʊ��ʽ
xticklabels({'0','18','31','4b','64','7e','97','b1','ca','e4','fe'});
xlabel("16����"),ylabel("��ѹ��ֵ")%xy����ע�ͺͱ���
title("DC����������ͼ��")