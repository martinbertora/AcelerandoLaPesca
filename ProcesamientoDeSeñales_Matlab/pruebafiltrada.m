clc
clear all
close all
load('senialesPrueba3')
 %load('4piquesgrabado')
%% Definicion de variables
muestreo=pique44pi.muestreo';
n=length(muestreo);
tiempo=zeros(1,n);
tiempo(1)=0;
%  for i=2:n
% tiempo(i)=(muestreo(i)+tiempo(i-1));
%  end
 for i=2:n
tiempo(i)=tiempo(i-1)+(5/1000);
 end
 Fs=200;

ACX=pique44pi.ACX';
ACY=pique44pi.ACY';
ACZ=pique44pi.ACZ';

% ACX=ACX-mean(ACX);
% ACY=ACY-mean(ACY);
% ACZ=ACZ-mean(ACZ);
SUMA=ACX+ACY+ACZ;
for i=1:n
SUMACUA(i)=(ACX(i)^2+ACY(i)^2+ACZ(i)^2)^(0.5);
end

linea=zeros(1,n);
 for i=1:n
linea(i)=0.05013;
 end
linea=linea';
%% Filtrado y ploteo (20 25 30 35 40)hz
p=[20 25 30 35 40]; %Frecuencias de filtrado
 p=[25]; %Frecuencias de filtrado
n=length(p);

figure()
plot(tiempo,SUMACUA);
hold on
title('Piques');
ylim([5 12.5])
ylabel("Aceleracion (m/s^2)")
xlabel("Tiempo (Seg)")
set(gca,'FontSize',14);
hold off
%Filtro Gauss
w=gausswin(64,1);
SUMACUA=SUMACUA';
t=tiempo';
figure()
for i=1:n
    %filtro butter
    m=10;%orden del filtro
    wn=(p(i))/(Fs/2);
    [b,a] = butter(m,wn,'High');
    x = filter(b,a,SUMACUA);
    x=abs(x);
    x=filtfilt(w/sum(w),1,x); %filtro de Gauss
    hold on
    plot(t,x);
end
legend('y20', 'y25','y30','y35','y40');
ylim([0 0.18])
title('Piques');
 plot(t,linea)
ylabel("Energia")
xlabel("Tiempo (Seg)")
set(gca,'FontSize',14);
hold off

%% Definicion de variables (Senial 2)
muestreo=olas1.muestreo';
n=length(muestreo);
tiempo=zeros(1,n);
tiempo(1)=0;
%  for i=2:n
% tiempo(i)=(muestreo(i)+tiempo(i-1));
%  end
 for i=2:n
tiempo(i)=tiempo(i-1)+(5/1000);
 end
 Fs=200;

ACX=olas1.ACX';
ACY=olas1.ACY';
ACZ=olas1.ACZ';

% ACX=ACX-mean(ACX);
% ACY=ACY-mean(ACY);
% ACZ=ACZ-mean(ACZ);

SUMA=ACX+ACY+ACZ;
for i=1:n
SUMACUA(i)=(ACX(i)^2+ACY(i)^2+ACZ(i)^2)^(0.5);
end

%% Filtrado y ploteo (20 25 30 35 40)hz
p=[20 25 30 35 40]; %Frecuencias de filtrado
 p=[25]; %Frecuencias de filtrado
n=length(p);

figure()
plot(tiempo,SUMACUA);
hold on
title('Olas');
ylim([5 12.5])
ylabel("Aceleracion (m/s^2)")
xlabel("Tiempo (Seg)")
set(gca,'FontSize',14);
hold off
%Filtro Gauss
w=gausswin(64,1);
SUMACUA=SUMACUA';
t=tiempo';
figure()
for i=1:n
    %filtro butter
    m=10;%orden del filtro
    wn=(p(i))/(Fs/2);
    [b,a] = butter(m,wn,'High');
    x = filter(b,a,SUMACUA);
    x=abs(x);
    x=filtfilt(w/sum(w),1,x); %filtro de Gauss
    hold on
    plot(t,x);
end
legend('y20', 'y25','y30','y35','y40');
ylim([0 0.18])
title('Olas');
 plot(t,linea)
ylabel("Energia")
xlabel("Tiempo (Seg)")
set(gca,'FontSize',14);
hold off