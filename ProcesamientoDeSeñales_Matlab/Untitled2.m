muestreo=prueba1.muestreo';
n=length(muestreo);
tiempo=zeros(1,n);
tiempo(1)=0;
%  for i=2:n
% tiempo(i)=(muestreo(i)+tiempo(i-1));
%  end
 for i=2:n
tiempo(i)=tiempo(i-1)+5;
 end
 Fs=(1/(5*1000));
ACX=prueba1.ACX';
ACY=prueba1.ACY';
ACZ=prueba1.ACZ';
SUMA=ACX+ACY+ACZ;
for i=1:n
SUMACUA(i)=(ACX(i)^2+ACY(i)^2+ACZ(i)^2)^(0.5);
end
SUMACUA=SUMACUA';
figure(1)
plot(tiempo,ACX);
hold on
plot(tiempo,ACY);
plot(tiempo,ACZ);
title('Prueba Ducha');
% Agregar una leyenda
legend('ACX', 'ACY', 'ACZ');
figure(2)
plot(tiempo,SUMA);
hold on
plot(tiempo,SUMACUA);
title('Prueba Ducha');

legend('SUMA', 'SUMACUA');

figure(3)
SUMACUA=SUMACUA-10
x=ACZ';
t=tiempo';
cfs = cwt(x,1000);
subplot(2,1,1);
plot(t,10*abs(cfs(1,:)),'LineWidth',2)
hold on
plot(t,x)
title('Wavelets Prueba Ducha');
hold off
[cfs,f] = cwt(x,Fs);
subplot(2,1,2);
imagesc(t,f,abs(cfs))
xlabel("Time (s)")
ylabel("Frequency (Hz)")
axis xy
title("Analisis espectral")

Pique=ACZ(5458:5892);


