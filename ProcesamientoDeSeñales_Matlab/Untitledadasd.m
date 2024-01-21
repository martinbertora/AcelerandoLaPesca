close all
muestreo=olas3.muestreo';
n=length(muestreo);
tiempo=zeros(1,n);
tiempo(1)=0;
%  for i=2:n
% tiempo(i)=(muestreo(i)+tiempo(i-1));
%  end
 for i=2:n
tiempo(i)=tiempo(i-1)+5;
 end
 Fs=200
ACZ1=olas1.ACZ';
ACZ2=olas2.ACZ';
ACZ3=olas3.ACZ';

ACZ4=pique1.ACZ';
ACZ5=pique24pi.ACZ';
ACZ6=pique33pi.ACZ';


%filtro butter
n=4;%orden del filtro
wn=5/(Fs/2);
[b,a] = butter(n,wn,'High');
x1 = filter(b,a,ACZ1);
x2 = filter(b,a,ACZ2);
x3 = filter(b,a,ACZ3);
x4 = filter(b,a,ACZ1);
x5 = filter(b,a,ACZ2);
x6 = filter(b,a,ACZ3);

figure()
y1=x1';
y2=x2';
y3=x3';
y4=x4';
y5=x5';
y6=x6';
t=tiempo';
cfs = cwt(y1,1000);
plot(t,y1)
hold on
plot(t,y2)
plot(t,y3)
title('olas filtradas');
legend('olas 1', 'olas 2', 'olas 3');
hold off
figure()
plot(t,y4)
hold on
plot(t,y5)
plot(t,y6)
title('piques filtradas');
legend('pique 1', 'pique 2', 'pique 3');
hold off

