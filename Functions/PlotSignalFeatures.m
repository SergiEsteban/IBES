function PlotSignalFeatures(handles)
global ecgResult pulseResult time SamplingRate
global R_pos S_Pos
global DBP SBP

if ~isempty(ecgResult)
    if isempty(pulseResult)
        RR_amps = findRR(ecgResult,R_pos,S_Pos);
        interp = spline(R_pos,RR_amps,R_pos(1):1:R_pos(length(R_pos)));
        [Peak_RR,Pos_RR,~] = pan_tompkin_revised(interp,SamplingRate,0.5);

        handles.CommonRRBP.Visible = 'on'; handles.RRAxes.Visible = 'off'; handles.BPAxes.Visible = 'off';
        axes(handles.CommonRRBP);
        plot(time(1:length(interp))+time(R_pos(1)),interp,'LineWidth',1,'color','r');hold on;
        title("Respiration profile");grid on;xlabel("Time [s]");ylabel("Amplitude [A.U]");
        plot(time(Pos_RR)+time(R_pos(1)),Peak_RR,'xB','LineWidth',2);hold off;
        RR_temp = diff(Pos_RR);
        RR_value = 60/(mean(RR_temp)/SamplingRate);
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Respiratory rate: ',num2str(RR_value),' resp/min']);
    else        
        RR_amps = findRR(ecgResult,R_pos,S_Pos);
        interp = spline(R_pos,RR_amps,R_pos(1):1:R_pos(length(R_pos)));
        [Peak_RR,Pos_RR,~] = pan_tompkin_revised(interp,SamplingRate,0.5);

        handles.CommonRRBP.Visible = 'off'; handles.RRAxes.Visible = 'on'; handles.BPAxes.Visible = 'on';
        axes(handles.RRAxes);
        plot(time(1:length(interp))+time(R_pos(1)),interp,'LineWidth',1,'color','r');hold on;
        title("Respiration profile");grid on;xlabel("Time [s]");ylabel("Amplitude [A.U]");
        plot(time(Pos_RR)+time(R_pos(1)),Peak_RR,'xB','LineWidth',2);hold off;
        
        axes(handles.BPAxes);
        plot(time(R_pos),DBP);hold on;
        plot(time(R_pos),SBP);
        title('SBP and DBP');legend('DBP','SBP');xlabel("Time [s]");ylabel("Blood pressure [mmHg]");
        hold off;
        
        RR_temp = diff(Pos_RR);
        RR_value = 60/(mean(RR_temp)/SamplingRate);
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Respiratory rate: ',num2str(RR_value),' resp/min']);
    end
end    
end

