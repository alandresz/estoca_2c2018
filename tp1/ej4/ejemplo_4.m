clear all            % Borramos todas las variables locales.                               
close all            % Cerramos archivos y ventanas abiertas.
clc                  % Limpio pantalla  


P_err=[];
P_err_posta=[];
i=1;
A=12;
h=0.9;               % Factor de atenuación
M = 2000;            % Cantidad de muestras a generar.
b_real=round(rand(1,M));  % Cantidad de bits
paso=5;

vector_SNR = 5:0.01:25;
parfor i=1:length(vector_SNR)
  SNR = vector_SNR(i);
  b=b_real;
  G = 1/h * sqrt(SNR/(1+SNR));
  S=A*(2*b-1); % Señal
  Potencia_N = (h*A)^2/(10^(SNR/10));
    for j=1:8
      N=sqrt(Potencia_N)*randn(size(S)); % N(0,sigma)
      Y=h*S+N; % Señal recibida

      S = G*Y; % Señal amplificada
    endfor

  b_hat=(sign(S)+ 1)/2;
  P_err(i)=nnz(b_real-b_hat)/M;
endparfor

semilogy(vector_SNR,P_err, 'b.')
ylim([10^-6 10^0])
grid on

hold on
n = 9;
SNR_dB_t = 5:25;
SNR_t = 10.^(SNR_dB_t/10);

%%% Probabilidad de error teorico en el repetidor analogico %%%

P_en_a_t = qfunc( (SNR_t.^(n/2)) ./ sqrt((SNR_t+1).^n - SNR_t.^n) ) ;

plot(SNR_dB_t,P_en_a_t,'r');
axis([5 25 1e-4 1]);
ylabel('Probabilidad de error')
xlabel('SNR (dB)')
legend('Simulación Montecarlo','Curva teórica analógica')
