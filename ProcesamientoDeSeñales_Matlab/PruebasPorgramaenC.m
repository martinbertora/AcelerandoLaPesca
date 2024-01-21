clc
clear all
close all
load('PruebaProgramadoenC')
%% Definicion de variables
SenialFiltrada=prueba3.FiltroGauss';
SUMACUA=prueba3.SumaCuadratica';
n=length(SenialFiltrada);
tiempo=zeros(1,n); 
tiempo(1)=0;
%  for i=1:n
% SenialFiltrada(i)=SenialFiltrada(i)-15.15;
% SenialFiltrada(i)=SenialFiltrada(i)^2;
%  end

 for i=2:n
tiempo(i)=tiempo(i-1)+(10/1000);
 end
 Fs=100;

%% Ploteo
figure() %Suma cuadratrica de las Aceleraciones en el tiempo
plot(tiempo,SenialFiltrada);
hold on
%plot(tiempo,SUMACUA);
title('Energia Boya Prueba 2');
ylabel("Aceleracion")
xlabel("Tiempo (Seg)")
legend('SeñalFiltrada');
set(gca,'FontSize',14);
hold off

%% Curvas ROC 
load('verdadprueba3');
Verdad=VerdadRCOprueba3.Verdad;
u=25;             %cantidad de muestras por ventana (0.25 seg son 25 muestras)
p=n/u;            % Calculo la cantidad de ventanas
Piques=zeros(1,n);
ValorMin=0;
ValorMax=411;

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
            if SenialFiltrada(k) > umbral
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
%text(Especificidad,Sensibilidad,num2str(h'));
xlabel('1-Especificidad');
ylabel('Sensibilidad');
grid on;
set(gca,'FontSize',14);
hold off

% load('PiquesROC')
% figure()
% plot(tiempo,SenialFiltrada);
% hold on
% title('Piques ROC');
% xlabel("Tiempo (Seg)")
% grid on
% hold off

%% Generacion de la señal con todos los piques
SenialA=prueba2.FiltroGauss';
SenialB=prueba4.FiltroGauss';
SenialTotal=zeros(1,20000);
SenialTotal=[SenialA SenialB];
n=length(SenialTotal);
tiempo=zeros(1,n); 
 for i=2:n
tiempo(i)=tiempo(i-1)+(10/1000);
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
load('VerdadROCPrueba2C');
Verdad1=VerdadROCPrueba2C.Verdad;
load('VerdadROCPrueba4C');
Verdad2=VerdadROCPrueba4C.Verdad;
Verdad=[Verdad1;Verdad2];

u=25;             %cantidad de muestras por ventana (0.25 seg son 25 muestras)
p=n/u;            % Calculo la cantidad de ventanas
Piques=zeros(1,n);
ValorMin=0;
ValorMax=500;

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