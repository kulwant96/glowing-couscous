clear all;
close all;
clc;

%% arduino
%arduino=serial('COM5','BaudRate',9600); % create serial communication object on port COM5

%% 
 %vid=videoinput('winvideo',1)

%for
%i=1;
 %  h=getsnapshot(vid);
  %  fname=['Image' num2str(i)];
   % imwrite(h,fname,'jpg');
    %pause(2);
    %figure,imshow(h);
%end

%% database  
[I,j,k,l,m,n]=ph;
level0 = graythresh(I);%converting intensity to binary format
 BWI = im2bw(I,level0);%converts the intensity image h to black and white.
 level1 = graythresh(j);
 BWj =im2bw(j,level1);
 level2 = graythresh(k);
 BWk =im2bw(k,level2);
  level3 = graythresh(l);
 BWl =im2bw(l,level2);
 level4 = graythresh(m);
 BWm = im2bw(m,level4);
 level5 = graythresh(n);
 BWn = im2bw(n,level5);
 
 %% voice
 [a,f]=audioread('002.mp3');
p = audioplayer(a,f);
[b,fs]=audioread('003.mp3');
q = audioplayer(b,fs);

 %% input the image through camera


h = imread('yy.jpeg');
        level = graythresh(h);%converting intensity to binary format
        BW = im2bw(h,level);%converts the intensity image h to black and white.
        figure, imshow(BW);
     %% 
   se = strel('disk', 20);
   Ie = imerode(h, se);
Iobr = imreconstruct(Ie, h);
figure
imshow(Iobr), title('Opening-by-reconstruction (Iobr)');
% Now use |imdilate| followed by |imreconstruct|.  Notice you must 
% complement the image inputs and output of |imreconstruct|.

Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
%figure
%imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)')

bw = im2bw(Iobrcbr, graythresh(Iobrcbr));
figure
imshow(bw), title('Thresholded opening-closing by reconstruction (bw)');
%figure

 %%
 bww = bwareaopen(bw,30);%removes from a binary image all connected
    %components (objects) that have fewer than 30 pixels
 figure,imshow(bww)
 [B,L] = bwboundaries(bww,'holes');
figure, imshow(label2rgb(L, @jet, [.5 .5 .5]));
hold on

for k = 1:length(B)
  boundary = B{k};
  plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end
%% 

stats = regionprops(L,'Area','Centroid');

threshold = 0.62;

% loop over the boundaries
for k = 1:length(B)

  % obtain (X,Y) boundary coordinates corresponding to label 'k'
  boundary = B{k};

  % compute a simple estimate of the object's perimeter
  delta_sq = diff(boundary).^2;   
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % obtain the area calculation corresponding to label 'k'
  area = stats(k).Area;
  
  % compute the roundness metric
  metric = 4*pi*area/perimeter^2;
  
  % display the results
  metric_string = sprintf('%2.2f',metric);

  % mark objects above the threshold with a black circle
  if length(BWI)==length(BW)||length(BWj)==length(BW)||length(BWk)==length(BW)||length(BWl)==length(BW)||length(BWm)==length(BW)||length(BWn)==length(BW)
    centroid = stats(k).Centroid;
    plot(centroid(1),centroid(2),'ko');
  end
  
 % text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
  %    'FontSize',14,'FontWeight','bold');
  
end
 
 if ((length(BW) < length(BWI))||(length(BW)> length(BWI)))&&((length(BW)> length(BWj))||(length(BW)< length(BWj)))&&((length(BW)< length(BWk))||(length(BW)> length(BWk)))&&((length(BW)< length(BWl))||(length(BW)> length(BWl)))&&...
         ((length(BW)< length(BWm))||(length(BW)> length(BWm)))&&((length(BW)< length(BWn))||(length(BW)> length(BWn)))
     disp('no pothole');
     play(q)
   %  fopen(arduino);
    %for i=1:1000
     %    answer=2;
     %initiate arduino communication
   % fprintf(arduino,'%s',char(answer))
    %end
     title('nopothole detected');
     
 end
 %%
 if length(BWI)==length(BW)||length(BWj)==length(BW)||length(BWk)==length(BW)||length(BWl)==length(BW)||length(BWm)==length(BW)||length(BWn)==length(BW)

     disp('pothole detected');
     play(p)
     %fopen(arduino);
    %for i=1:1000
     %    answer=1;
     %initiate arduino communication
    %fprintf(arduino,'%s',char(answer))
    %end
     title(['pothole detected']);
     
 end
 
 %fclose(arduino);