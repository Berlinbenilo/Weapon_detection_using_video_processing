load('Detector.mat');

% Detect = vision.CascadeObjectDetector('Nose');
% BB=step(Detect,I);
% figure,imshow(I);
% rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','b');
% title('Nose Detection');



results = struct('Boxes',[],'scores',[]);


    I = imread('download.jpg');
    [bboxes,scores] = detect(detector,I,'threshold',1);
   
    [~,idx] = max(scores);
    
    annotation = sprintf('%s, Confidence %4.2f',detector.ModelName,scores(idx));
    vidPlayer = insertObjectAnnotation(I,'rectangle',bboxes(idx,:),annotation);

    step(vidPlayer,I);

    i = i+1;

    results = struct2table(results);
