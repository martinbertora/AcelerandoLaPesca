clc
clear all
close all
load('senialesPrueba3')
%%
muestreo=olas2.muestreo';
n=length(muestreo);
tiempo=zeros(1,n);
tiempo(1)=0;
%  for i=2:n
% tiempo(i)=(muestreo(i)+tiempo(i-1));
%  end
 for i=2:n
tiempo(i)=tiempo(i-1)+(5/1000);
 end
 Fs=200

ACX=olas2.ACX;
ACY=olas2.ACY;
ACZ=olas2.ACZ;
ACZ1=olas2.ACZ;

%filtro
Fs=200;
%filtro butter
wn=5/(Fs/2);
[b,a] = butter(10,0.25);
%fvtool(b,a)
% y1 = filtfilt(b,a,x);
% ACX=filtfilt(b,a,ACX);
% ACY=filtfilt(b,a,ACY);
% ACZ=filtfilt(b,a,ACZ);

SUMA=ACX+ACY+ACZ;
for i=1:n
SUMACUA(i)=(ACX(i)^2+ACY(i)^2+ACZ(i)^2)^(0.5);
end

x = filter(b,a,ACZ);
figure()
plot(tiempo,ACX);
hold on
plot(tiempo,ACY);
plot(tiempo,ACZ);
title('Prueba Ducha');
% Agregar una leyenda
legend('ACX', 'ACY', 'ACZ');
set(gca,'FontSize',14);
figure()
plot(tiempo,SUMA);
hold on
plot(tiempo,x);
title('Prueba Ducha');
set(gca,'FontSize',14);
legend('SUMA', 'SUMACUA');

figure()
% SUMA=SUMA-10
% x=SUMA';
t=tiempo';
cfs = cwt(x,1000);
subplot(2,1,1);
plot(t,10*abs(cfs(1,:)),'LineWidth',2)
hold on
plot(t,x)
title('Wavelets Olas');
set(gca,'FontSize',14);
hold off
[cfs,f] = cwt(x,Fs);
subplot(2,1,2);
imagesc(t,f,abs(cfs*100))
xlabel("Tiempo (s)")
ylabel("Frecuencia (Hz)")
axis xy
title("Analisis espectral")
set(gca,'FontSize',14);
%%
x=SUMACUA;
fs = 200; % Frecuencia de muestreo en Hz

%Filtro
x=x';
%Filtro
% [b,a] = butter(4,0.25);
% y1 = filtfilt(b,a,x);

% Parámetros para pwelch
window = hamming(256); % Ventana de Hamming (puedes elegir otra)
noverlap = 128; % Superposición entre ventanas (ajusta según necesites)
nfft = 1024; % Número de puntos de la FFT (ajusta según necesites)

% Calcular la PSD
[Pxx, f] = pwelch(x, window, noverlap, nfft, fs);

% Gráfico de la PSD
figure();
plot(f, 10*log10(Pxx)); % Escala logarítmica en dB
xlabel('Frecuencia (Hz)');
ylabel('PSD (dB/Hz)');
set(gca,'FontSize',14);
title('Densidad Espectral de Potencia: Olas');

%%
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
SUMA=ACX+ACY+ACZ;
for i=1:n
SUMACUA(i)=(ACX(i)^2+ACY(i)^2+ACZ(i)^2)^(0.5);
end
SUMA=SUMA';
figure()
plot(tiempo,ACX);
hold on
plot(tiempo,ACY);
plot(tiempo,ACZ);
% Agregar una leyenda
legend('ACX', 'ACY', 'ACZ');
figure()
plot(tiempo,SUMA);
hold on
plot(tiempo,SUMACUA);
set(gca,'FontSize',14);
legend('SUMA', 'SUMACUA');

figure()
SUMA=SUMA-10;
x=SUMA';
t=tiempo';
cfs = cwt(x,1000);

subplot(2,1,1);
plot(t,10*abs(cfs(1,:)),'LineWidth',2)
hold on
plot(t,x)
title('Wavelets Piques');
hold off
[cfs,f] = cwt(x,Fs);
set(gca,'FontSize',14);
subplot(2,1,2);
imagesc(t,f,abs(cfs))
xlabel("Tiempo (s)")
ylabel("Frecuencia (Hz)")
axis xy
title("Analisis espectral")
set(gca,'FontSize',14);
%%
x=SUMACUA;
fs = 200; % Frecuencia de muestreo en Hz

%Filtro
% [b,a] = butter(4,0.25);
% y1 = filtfilt(b,a,x);

% Parámetros para pwelch
window = hamming(256); % Ventana de Hamming (puedes elegir otra)
noverlap = 128; % Superposición entre ventanas (ajusta según necesites)
nfft = 512; % Número de puntos de la FFT (ajusta según necesites)

% Calcular la PSD
[Pxx, f] = pwelch(x, window, noverlap, nfft, fs);

% Gráfico de la PSD
figure();
plot(f, 10*log10(Pxx)); % Escala logarítmica en dB
xlabel('Frecuencia (Hz)');
ylabel('PSD (dB/Hz)');
title('Densidad Espectral de Potencia: Piques');
ylim([-80 40]);
set(gca,'FontSize',14);
