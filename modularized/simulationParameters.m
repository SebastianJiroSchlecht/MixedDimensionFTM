function sim = simulationParameters()

sim.Fs = 48000;
sim.T = 1/Fs;
sim.duration = 1; 
sim.t = 0 : sim.T : sim.duration-sim.T;



