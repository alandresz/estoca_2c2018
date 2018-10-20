clear all            % Borramos todas las variables locales.                               
close all            % Cerramos archivos y ventanas abiertas.
clc                  % Limpio pantalla  


P_err=[];
P_err_posta=[];
i=1;
A=12;
h=0.9;               % Factor de atenuación
M = 200000;           % Cantidad de muestras a generar.
b_real=round(rand(1,M));  % Cantidad de bits

parfor SNR=5:0.01:25
  b=b_real;
  for j=1:9
      S=A*(2*b-1);         % Señal
      Potencia_N= (h*A)^2/(10^(SNR/10));%va a ser var(Normal) 
                                        %divide pot de Satenuada
                                        %con la reglita del logaritmo

      N=sqrt(Potencia_N)*randn(size(S)); % N(0,sigma)

      X=h*S+N;              % Señal transmitida
      b_hat=(sign(X)+ 1)/2;
  
      b=b_hat;
   endfor
   P_err(i)=nnz(b_real-b_hat)/M;
   i=i+1;
endparfor

SNR_vec=5:0.01:25;
P_err;
semilogy(SNR_vec,P_err, 'b.')
grid on

hold on

n = 1:4:25;
SNR_dB = (5):25;
SNR = 10.^(SNR_dB/10);

%%%   Probabilidad de error teorico en el repetidor digital   %%%

P_en =  (1/2)*( 1 - bsxfun(@power , (1-2*qfunc(sqrt(SNR))) , transpose(n) ) )  ;

plot(SNR_dB,P_en(3,:),'r');
axis([5 25 1e-4 1]);

%set(gca, 'YScale', 'log')

ylabel('Probabilidad de error')
xlabel('SNR (dB)')
legend('Simulación Montecarlo','Curva teórica digital')

 
