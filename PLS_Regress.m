function [sol, yhat] = PLS_Regress(x, y)
% �������ܣ�ƫ��С���˻ع�
% =============================================================
% ���룺
%   x���Ա�����
%   y���������
% �����
%   sol���ع�ϵ����ÿһ����һ���ع鷽�̣��ҵ�һ��Ԫ���ǳ����
%   yhat�����ֵ
% ���ø�ʽ��
%{
clear;clc;
pz = load('pz3_3.txt');
x = a(:, 1:3);
y = a(:, 4:6);
[sol, yhat] = PLS_Regress(x, y);
subplot(3, 1, 1)
bar([yhat(:, 1), y(:, 1)]);
subplot(3, 1, 2)
bar([yhat(:, 2), y(:, 2)]);
subplot(3, 1, 3)
bar([yhat(:, 3), y(:, 3)]);
%}
% =============================================================
[rX, n] = size(x);           % �Ա�������
[rY, m] = size(y);           % ���������
assert(rX == rY, 'x��y�ĺ���ά�Ȳ�һ�£�');
%%% ��׼������
xmean = mean(x);    % ÿһ�о�ֵ
xstd = std(x);           % ÿһ�б�׼��
ymean = mean(y);    % ÿһ�о�ֵ
ystd = std(y);           % ÿһ�б�׼��
e0 = (x - xmean(ones(rX, 1), :))./xstd(ones(rX, 1), :);
f0 = (y - ymean(ones(rY, 1), :))./ystd(ones(rY, 1), :);
%%% ��������
chg = eye(n);          % w��w*�任����ĳ�ʼ��
w = zeros(n, n);
w_star = zeros(n, n);
t = zeros(rX, n);
ss = zeros(1, n);
press_i = zeros(1, rX);
press = zeros(1, n);
Q_h2 = zeros(1, n);
for i = 1:n
    %%%  ���¼���w��w*��t�ĵ÷�����
    %%% ��ȡ�������ֵ�Ͷ�Ӧ����������
    w(:, i) = Max_Eig(f0'*e0);
    w_star(:, i) = chg*w(:, i);                   % ����w*��ȡֵ
    t(:, i) = e0*w(:, i);                               % ����ɷ�ti�ĵ÷�
    alpha = e0'*t(:, i)/(t(:, i)'*t(:, i));           % ����alpha_i
    chg = chg*(eye(n) - w(:, i)*alpha');      % ����w��w*�ı任����
    e = e0 - t(:, i)*alpha';                            % ����в�
    e0 = e;
    %%% ���¼���ss(i)��ֵ
    beta = [t(:, 1:i), ones(rX, 1)]\f0;            % ��ع鷽�̵�ϵ��
    beta(end, :) = [];                                      % ɾ���ع�����ĳ�����
    cancha = f0 - t(:, 1:i)*beta;                     % �в�
    ss(i) = norm(cancha)^2;                           % ���ƽ����
    %%% ���¼���press(i)
    for j = 1:rX
        t1 = t(:, 1:i);
        f1 = f0;
        she_t = t1(j, :);              % ������ȥ�ĵ�j��������
        she_f = f1(j, :);
        t1(j, :) = [];                     % ɾ����j���۲�ֵ
        f1(j, :) = [];
        beta1 = [t1, ones(rX - 1, 1)]\f1;        % ��ع������ϵ��
        beta1(end, :) = [];              % ɾ���ع�����ĳ�����
        cancha = she_f - she_t*beta1;          % �в�
        press_i(j) = norm(cancha)^2;             
    end
    press(i) = sum(press_i);
    if i > 1
        Q_h2(i) = 1 - press(i)/ss(i - 1);
    else
        Q_h2(i) = 1;
    end
    if Q_h2(i) < 0.0975
        fprintf('����ĳɷָ���r=%d\n', i);
        r = i;
        break;
    end
end
beta_z = [t(:, 1:r), ones(rX, 1)]\f0;            % ��Y����t�Ļع�ϵ��
beta_z(end, :) = [];                                       % ɾ��������
xishu = w_star(:, 1:r)*beta_z;     % ��Y���ڱ�׼����X�Ļع�ϵ����ÿһ����һ���ع鷽��
%%% ����ԭʼ���ݵĻع鷽�̵ĳ�����
ch0 = zeros(1, m);
for i = 1:m
    ch0(i) = ymean(i) - xmean./xstd*ystd(i)*xishu(:, i);    
end
% ����ԭʼ���ݵĻع鷽�̵�ϵ����ÿһ����һ���ع鷽��
xish = zeros(n, m);
for i = 1:m
    xish(:, i) = xishu(:, i)./xstd'*ystd(i);    
end
sol = [ch0; xish];    
yhat = [ones(size(x, 1), 1), x]*sol;
end
 
%%% �������ֵ��Ӧ����������
function Eigenvector = Max_Eig(A)
B = A'*A;
% ������������
[~, idx] = max(sum(B));
x = A(:, idx);
% �������ж�
x0 = x - x;
% ����
Eigenvector = A'*x;  
while norm(x - x0) > 1e-8
    Eigenvector = A'*x;              % ������������ 
    Eigenvector = Eigenvector/norm(Eigenvector);       % ��һ��    
    x0 = x;                   % ����
    x = A*Eigenvector;
end
end
