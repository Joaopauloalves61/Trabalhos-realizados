h = 1e-6;                               % passo de tempo  (s)
timeMax = 0.05;                         % tempo maximo    (s)
numPoints = round(timeMax/h);           % numero de passos 
t = 0:h:numPoints*h-h;                  % vetor tempo
vetor = zeros(2,numPoints);
chave = false;                            %Chave de boost


CT = 0.5;                               %Ciclo de trabalho
f = 5e+3;
R = 4;                                  % resistencia (Ohm)
L = 1e-3;                               % indutancia  (Henry)
V = 1;                                  % tensao      (V)
C = 1e-3;                               % capacitancia (F)
Meiop = 1/(2*f);
sinal = zeros(1,numPoints);


A1 = [-1/(R*C) 1/C;-1/L 0];            % matriz de constantes
A0 = [-1/(R*C) 0;0 0];
B = [0;1/L];
pt=0;
ct=0;
for k = 2:numPoints
    % insira seu codigo aqui
    pt = t(k) * f;
    tc = pt - floor(pt);
    if tc < CT
        chave =false;
        sinal(k)=1;
    end
    if tc > CT
        chave=true;
        sinal(k)=0;
    end
    
    if chave == true
        vetor(:,k)= (eye(length(A1)) - h*A1)^-1*(vetor(:,k-1)+ h*V*B);
    end
    
    if chave == false
        vetor(:,k)= (eye(length(A0)) - h*A0)^-1*(vetor(:,k-1)+ h*V*B);
    end
    %if sign(sin(t(k)*f*pi))>= 0
    %    chave = true;  
    %    sinal(k) = 1;
    %end
    %if sign(sin(t(k)*f*pi))/(CT*2)< 0
    %    chave = false;
    %end
    k;
end

%fileID=fopen('MatLabNaochaveado.txt',r);
%formatSpec = '%f %f %f %f';
%sizeM = [Inf 4];
%M = fscanf(fileID,formatSpec,sizeM)

figure(1)
title('circuito RLC')
plot(t,vetor(1,:),'b')
grid on
ylabel('Corrente (A)\ Tensao(V)')
xlabel('Tempo (s)')
hold on
plot(t,vetor(2,:),'r')
plot(Tempo_FPGA, Valores_FPGA/1365, 'g')
legend('Tensao no capacitor no MATLAB','Corrente no indutor no MATLAB', 'Tensao simulada na FPGA')

grid on

figure(2)
title('circuito RLC')
plot(Tempo_FPGA, Valores_FPGA/1365,'b')
grid on
ylabel('Corrente (A)\ Tensao(V)')
xlabel('Tempo (s)')
hold on
plot(t,sinal,'g')
legend('Tensao na FPGA','sinal')
hold off