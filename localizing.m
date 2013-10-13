% To capture images off from Kinect
Kinect_images;
 
I = imread( 'demoday3.jpg' );

I(:, end:-1:1, :) = I;

[wPt, iPt] = caltag( I, 'mypattern.mat', false );imshow(I);hold on;plot(iPt(:,2),iPt(:,1),'rx','LineWidth',10);

meanx = mean(iPt(:,2));
meany = mean(iPt(:,1));

%% NOW FIND DEPTH TO THIS X Y POSITION 

playgroundepth(:, end:-1:1, :) = playgroundepth;

camerapos = playgroundepth(floor(meany),floor(meanx));
if(camerapos == 0)
    for i=1:size(iPt)
        camerapos = playgroundepth(floor(iPt(i,1)),floor(iPt(i,2)));
    end
end

fprintf('The camera is %d mm away from the frame',camerapos); 

%% Working out pose. 
first=[];
middle1=[];
middle2=[];
last =[];

for i=1:size(iPt,1)
    if wPt(i,1)==0
        first=[iPt(i,1) iPt(i,2)];
        break
    end
end
for i=1:size(iPt,1)
    if wPt(i,1)==6
        last=[iPt(i,1) iPt(i,2)];
        break
    end
end
for i=1:size(iPt,1)
    if wPt(i,1)==3
        middle1=[iPt(i,1) iPt(i,2)];
        break
    end
end
for i=1:size(iPt,1)
    if wPt(i,2)==3
        middle2=[iPt(i,1) iPt(i,2)];
        break
    end
end

angleyaw = atand((last(1)-first(1))/(last(2)-first(2)))
depthdiff = playgroundepth(floor(last(1)),floor(last(2))) - playgroundepth(floor(first(1)),floor(first(2)));
dist = sqrt((last(1)-first(1))^2 + (last(2)-first(2))^2);

anglepitch = atand(double(depthdiff)/120)
depthdiff = playgroundepth(floor(middle1(1)),floor(middle1(2))) - playgroundepth(floor(middle2(1)),floor(middle2(2)));
dist = sqrt((last(1)-first(1))^2 + (last(2)-first(2))^2);

angleroll = atand(double(depthdiff)/80)

