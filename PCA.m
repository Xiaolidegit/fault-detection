function [i,NEW]=PCA(xfc,delta_t)           
M=xfc;                  %Э����
[V,D]=eig(M);             %���Э������������������������
d=diag(D);                %ȡ����������������������ȡ��ÿһ���ɷֵĹ����ʣ�
eig1=sort(d,'descend');     %�������ʰ��Ӵ�СԪ������
v=fliplr(V);                %����D����������������
S=0;
i=0;
while S/sum(eig1)<0.85
    i=i+1;
    S=S+eig1(i);
end  
alpha=v(:,1:i);
NEW=delta_t*v(:,1:i); 
end