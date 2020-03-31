function plotTransferFunction(T12,s,r,string,shouldSave,saveString)

% TODO: clean up

%% Analyze T12
[f,fInd] = sort(s2f(r.ftm.smu(1:end/2)),'ascend');
T12_ = T12(1:end/2,1:end/2);


figure(152);
plotMatrix(clip(mag2db(abs(T12_(fInd,:))),[-50 10]));
xticks((1:length(s.ftm.smu(1:end/2)))+0.5)
xticklabels(round(s2f(s.ftm.smu(1:end/2))));
yticks((1:100:length(f))+0.5)
yticklabels(round(f(1:100:end)));
xlabel('String Frequency [Hz]')
ylabel('Room Frequency [Hz]')
colorbar;
axis tight;


if shouldSave
   options = {'xticklabel style={rotate=90}'};
   matlab2tikz_sjs(['./plot/ConnectionMatrix_' saveString '.tikz'],'height','11.6cm','width','3cm','extraAxisOptions',options);
end


%% Plot Transfer Function
w = 1i*linspace(0,10000,1000);
stringOut = 1./(w - diag(s.state.As)) .* s.state.Ks4_xe;
stringPickup = s.state.Cw * stringOut;
roomIn = T12 * stringOut;
roomOut = 1./(w - diag(r.state.As)) .* roomIn;
roomPickup = r.state.C * roomOut;

% Impulse excitation at string.mid
init = r.ftm.primKern1(string.mid.x,string.mid.y, 1:r.ftm.Mu);
roomTFPoint = r.state.C * (1./(w - diag(r.state.As)) .* init);

% Transfer Functions
figure(432); hold on; grid on;
lin2dB = @(x) clip(mag2db(abs(x)),[-100 40]);
plot(s2f(w),lin2dB(stringPickup))
plot(s2f(w),lin2dB(roomPickup))
xlabel('Frequency [s]')
ylabel('Magnitude [dB]')
legend({'String Pickup', 'Room Pickup'},'Location','SouthEast');


if shouldSave
   matlab2tikz_sjs(['./plot/TransferFunction_' saveString '.tikz'],'height','3.0cm');
end


% Relative Transfer Function
figure(433); hold on; grid on;
lin2dB = @(x) clip(mag2db(abs(x)),[-100 200]);
plot(s2f(w),lin2dB(roomPickup ./ stringPickup))
plot(s2f(w),lin2dB(roomTFPoint))
xlabel('Frequency [s]')
ylabel('Magnitude [dB]')
legend({'Room to String Relative Transfer Function', 'Room to Point Relative Transfer Function'},'Location','SouthEast');

if shouldSave
   matlab2tikz_sjs(['./plot/Relative_TransferFunction_' saveString '.tikz'],'height','3.0cm');
end