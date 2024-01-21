clc
clear all
close all
load('pruebasToma1BoyaSepadada')
load('4piquesgrabado')
%% Definicion de variables
muestreo=piquededeabajo3piquesultimolargo.muestreo';
n=length(muestreo);
tiempo=zeros(1,n);
tiempo(1)=0;
%  for i=2:n
% tiempo(i)=(((muestreo(i))/1000)+tiempo(i-1));
%  end
 for i=2:n
tiempo(i)=tiempo(i-1)+(5/1000);
 end
 Fs=200;

ACX=piquededeabajo3piquesultimolargo.ACX';
ACY=piquededeabajo3piquesultimolargo.ACY';
ACZ=piquededeabajo3piquesultimolargo.ACZ';

ACX=ACX-mean(ACX);
ACY=ACY-mean(ACY);
ACZ=ACZ-mean(ACZ);
SUMA=ACX+ACY+ACZ;
for i=1:n
SUMACUA(i)=(ACX(i)^2+ACY(i)^2+ACZ(i)^2)^(0.5);
end


%% Filtrado y ploteo (Gauss)

figure() %Suma cuadratrica de las Aceleraciones en el tiempo
plot(tiempo,SUMACUA);
hold on
title('Piques');
xlabel("Tiempo (Seg)")
hold off

SUMACUA=SUMACUA';
t=tiempo';
%Filtro Gauss
w=gausswin(512,3);
x=filtfilt(w/sum(w),1,SUMACUA); %filtro de Gauss
figure() %Senial Filtrada con un filtro Gausseano
plot(t,x);
hold on
legend('Señal Filtrada');
title('Fltro de Gauss: Piques');
ylim([0 9]);
xlabel("Tiempo (Seg)")
set(gca,'FontSize',14);
grid on
hold off

%% Curvas ROC 
load('verdadprueba3');
Verdad=VerdadRCOprueba3.Verdad;
u=50;             %cantidad de muestras por ventana (0.25 seg son 50 muestras)
p=n/u;            % Calculo la cantidad de ventanas
Piques=zeros(1,n);
ValorMin=0.801;
ValorMax=8.553;

umbral=ValorMin;
NumeroUmbrales=100;
Paso=(ValorMax-ValorMin)/NumeroUmbrales;
Sensibilidad=zeros(1,NumeroUmbrales);
Especificidad=zeros(1,NumeroUmbrales);
% Positivos=zeros(1,p);
for h=1:NumeroUmbrales %Actualiza el Umbral y calcula
    VP=0;
    VN=0;
    FP=0;
    FN=0;
    for i=1:p  %Cada ciclo es el estudio de una ventana
        
        for k=((i-1)*u)+1:(i*u) %Cicla todos los datos de una ventana
            %Definir la Senial de Piques Verdaderos
            if x(k) > umbral
                Positivo=1;
                break
            else
                Positivo=0;
            end               
                     
        end
        
        if (Positivo == Verdad(i)) && (Positivo ==1)
            VP=VP+1;
        elseif (Positivo == Verdad(i)) && (Positivo ==0)
            VN=VN+1;
        elseif (Positivo ==0) && (Positivo ~= Verdad(i))
            FN=FN+1;
        elseif (Positivo ==1) && (Positivo ~= Verdad(i))
            FP=FP+1;
        end
        
        
    end
    Sensibilidad(h)=(VP)/(VP+FN);
    Especificidad(h)=1-(VN)/(VN+FP);
    umbral=umbral+Paso;
end
figure()
plot(Especificidad,Sensibilidad, 'o');
hold on
title('Gráfico de Sensibilidad vs Especificidad');
xlabel('1-Especificidad');
ylabel('Sensibilidad');
grid on;
hold off

load('PiquesROC')
figure()
plot(t,Piques);
hold on
plot(t,x);
legend('Piques', 'Señal Completa');
title('Piques ROC');
ylim([0 9]);
xlabel("Tiempo (Seg)")
set(gca,'FontSize',14);
grid on
hold off

%% Generacion de la señal con todos los piques
load('piques4ultimograbadosinzoomfiltrada');
SenialA=x';
load('piquededeabajo3piquesultimolargofiltrada');
SenialB=x;
load('piquesvariosdeabajofiltrada');
SenialC=x;
SenialTotal=zeros(1,60000);
SenialTotal=[SenialA SenialB SenialC];
n=length(SenialTotal);
tiempo=zeros(1,n); 
 for i=2:n
tiempo(i)=tiempo(i-1)+(5/1000);
 end

figure() %Suma cuadratrica de las Aceleraciones en el tiempo
plot(tiempo,SenialTotal);
hold on
%plot(tiempo,SUMACUA);
title('Energía Boya');
ylabel("Aceleracion")
xlabel("Tiempo (Seg)")
legend('SeñalFiltrada');
set(gca,'FontSize',14);
hold off

%% Curvas ROC 
load('VerdadROC');
Verdad1=VerdadROC.Verdad;
load('verdadprueba3');
Verdad2=VerdadRCOprueba3.Verdad;
load('verdadprueba2');
Verdad3=verdadprueba2.Verdad;
Verdad=[Verdad1;Verdad2;Verdad3];
u=50;             %cantidad de muestras por ventana (0.25 seg son 50 muestras)
p=n/u;            % Calculo la cantidad de ventanas
Piques=zeros(1,n);
ValorMin=0.801;
ValorMax=8.553;

umbral=ValorMin;
NumeroUmbrales=100;
Paso=(ValorMax-ValorMin)/NumeroUmbrales;
Sensibilidad=zeros(1,NumeroUmbrales);
Especificidad=zeros(1,NumeroUmbrales);
% Positivos=zeros(1,p);
Umbrales=zeros(1,NumeroUmbrales);
Umbrales(1)=ValorMin;
for h=2:NumeroUmbrales
    Umbrales(h)=Umbrales(h-1)+Paso;
end
for h=1:NumeroUmbrales %Actualiza el Umbral y calcula
    VP=0;
    VN=0;
    FP=0;
    FN=0;
    for i=1:p  %Cada ciclo es el estudio de una ventana
        
        for k=((i-1)*u)+1:(i*u) %Cicla todos los datos de una ventana
            %Definir la Senial de Piques Verdaderos
            if SenialTotal(k) > umbral
                Positivo=1;
                break
            else
                Positivo=0;
            end               
                     
        end
        
        if (Positivo == Verdad(i)) && (Positivo ==1)
            VP=VP+1;
        elseif (Positivo == Verdad(i)) && (Positivo ==0)
            VN=VN+1;
        elseif (Positivo ==0) && (Positivo ~= Verdad(i))
            FN=FN+1;
        elseif (Positivo ==1) && (Positivo ~= Verdad(i))
            FP=FP+1;
        end
        
        
    end
    Sensibilidad(h)=(VP)/(VP+FN);
    Especificidad(h)=1-(VN)/(VN+FP);
    umbral=umbral+Paso;
end
h=1:NumeroUmbrales;
figure()
plot(Especificidad,Sensibilidad, 'o');
hold on
title('Gráfico de Sensibilidad vs Especificidad');
text(Especificidad,Sensibilidad,num2str(Umbrales'));
xlabel('1-Especificidad');
ylabel('Sensibilidad');
grid on;
set(gca,'FontSize',14);
hold off
