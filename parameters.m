clc; clear; close all;

vdc = 45;
rs = 0.25;
p = 8;
Lss = 0.375e-3;
lambdam = 21.5e-3;
J = 0.22e-3;
Tfirc = 0.12;
psiv = 0;

save('circuit_params.mat', 'vdc', 'rs', 'p', 'Lss', 'lambdam', 'J', 'Tfirc', 'psiv');
load('circuit_params.mat');