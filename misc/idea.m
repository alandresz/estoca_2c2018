clear all
close all

rand("state",992);

N = 100; % Cantidad simbolos a simular
A = 12; % Amplitud de los simbolos

h = 0.9; % Atenuacion canal
pnoise = 1.5; % Potencia del ruido AWGN del canal
Netapas = 10; % Cantidad de retrasmisiones

% Grafico
figure
hold on

% Creo simbolos
data = rand(1,N) > 0.5;
t = 1:length(data);
X = A*(2*data-1);
plot(t, X, '.');

% Retransmisión
Y(1,:) = X; % Original
for i=2:Netapas
  Y(i,:) = h*Y(i-1,:) + sqrt(pnoise)*randn(size(X));
endfor

plot(t(data==1), Y(end,data==1), 'bo');
plot(t(data==0), Y(end,data==0), 'go');


% Deteccion
Xrecibido = Y(end,:) > 0; 
bits_errados = Xrecibido != data;
cantidad_errores = nnz(bits_errados);
taza_errores = cantidad_errores/N;

disp(cantidad_errores);
disp(taza_errores);

% Muestro el error
plot(t(bits_errados), Y(end, bits_errados), 'rx');
title(sprintf("\sigma^2 = %.3g", pnoise));
legend("original", "recibida", "bit errado");