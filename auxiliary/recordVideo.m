function recordVideo(wantToRecord, videoName, func)
% Sebastian J. Schlecht, Saturday, 21 March 2020

if wantToRecord
    v = VideoWriter(['./plot/' videoName],'MPEG-4');
    open(v);
else
    v = [];
end

func(wantToRecord, v);

if wantToRecord
   close(v); 
end