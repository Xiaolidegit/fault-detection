function RollAf=lisanlvbo(data)
 m = size(data,1);
 da = data';
 Fs = 100;%����Ƶ��
 Wp = 5/(Fs/2); %ͨ����ֹƵ��,����Զ����¶���
 Ws = 10/(Fs/2);%�����ֹƵ��,����Զ����¶���
 Rp = 2; %ͨ���ڵ�˥��������Rp,����Զ����¶���
 Rs = 40;%����ڵ�˥����С��Rs������Զ����¶���
 [n,Wn] = buttord(Wp,Ws,Rp,Rs);%������˹�����˲�����С����ѡ����
 [b,a] = butter(n,Wn);%������˹�����˲���
 [h,w] = freqz(b,a,512,Fs); %�����˲�����Ƶ����Ӧ
%plot(w,abs(h))%,'LineWidth',1�����˲����ķ�Ƶ��Ӧͼ
%**************************************************************************

%��������źŽ����˲�
for i=1:m
  SA = da(:,i);
  RollAf(:,i) = filtfilt(b,a,SA);%filtfilt���������0��λ�˲���û��ƫ�ơ�filter��ƫ�ơ�
end
RollAf=RollAf';
%%  �˲������ͼ

%figure
%plot(Time,SA,Time,RollAf,'r--');

