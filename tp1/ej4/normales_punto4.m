clear all            % Borramos todas las variables locales.                               
close all            % Cerramos archivos y ventanas abiertas.
clc                  % Limpio pantalla  
normpdf_ = @(x, mu, sigma) 1/sqrt(2*pi*sigma^2) * exp(-(x-mu).^2 / (2*sigma^2));
fdp = @(x) hist(x/sum(x));

A=12;
h=0.9;               % Factor de atenuación
M = 20000000;            % Cantidad de muestras a generar.
n=9; % Cantidad de repetidores
SNR=5;
G= sqrt(SNR/(1+SNR)); % ganancia
E_Yn_A= A*h*G^(n-1); % esperanza de Y dado X=A
sigma= sqrt(0.2) %varianza de las Wi



for i=1:9
  G_ruido=G+(h*G)^(2*(n-i));
endfor

V_Yn_A=G_ruido*sigma;
Yn_A= -30:0.1:30;

fyn_a=normpdf_(Yn_A,E_Yn_A,V_Yn_A);
plot(Yn_A,fyn_a);
hold on;
grid on;

%Caso -A
E_Yn_A=-E_Yn_A;
fyn_a=normpdf_(Yn_A,E_Yn_A,V_Yn_A);
plot(Yn_A,fyn_a);
grid on;



%Caso simulacion con X1=A
M=100000;
W=randn(n,M)*sigma;
X1=A;
Yn_noise=zeros(1,M);
for k=1:1:M
    for i=1:1:n
        Yn_noise(1,k)=Yn_noise(1,k)+W(i,k)*G^(n-i);
    end
end
Yn=X1*G^(n-1)+Yn_noise;
[f,x]=hist(Yn,100);
plot(x,f/(trapz(x,f)),'b.');
%histogram(Yn);
%-----------------------------------------------
%Caso simulacion con X1=-A
M=100000;
W=randn(n,M)*sigma;
X1=-A;
Yn_noise=zeros(1,M);
for k=1:1:M
    for i=1:1:n
        Yn_noise(1,k)=Yn_noise(1,k)+W(i,k)*G^(n-i);
    end
end
Yn=X1*G^(n-1)+Yn_noise;
%histogram(Yn);
[f,x]=hist(Yn,100);
plot(x,f/(trapz(x,f)),'r.');
axis([-10 10 0 .6])
ylabel('Densidad de probabilidad')
xlabel('yn')
legend('f_{Y_n | {X=A}}','f_{Y_n | {X=-A}}','Sim f_{Y_n | {X=A}}','Sim f_{Y_n | {X=-A}}')

