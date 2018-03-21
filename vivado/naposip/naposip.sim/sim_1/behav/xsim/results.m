load C:/Users/Botix/Desktop/TDC/vivado/naposip.sim/sim_1/behav/xsim/myfile.txt
M=[myfile(1:3:end) myfile(2:3:end) myfile(3:3:end)]
P=diff(M,1,1)
plot(P)
legend("DL_TDC", "VDL_TDC", "GRO_TDC");