video = VideoWriter('stringOsc1','MPEG-4'); %create the video object
video.FrameRate = 10;
open(video); %open the file for writing
for k=1:100:84000 %where N is the number of images
  I = imread(sprintf('./Video_string_full_1/img%03d.png',(k-1))); %read the next image
  writeVideo(video,I); %write the image to file
end
% for k=73601:100:108400%where N is the number of images
%   I = imread(sprintf('./Video_string_full_2/img%03d.png',(k-1))); %read the next image
%   writeVideo(video,I); %write the image to file
% end
close(video); %close the file