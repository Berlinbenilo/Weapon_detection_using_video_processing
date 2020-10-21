load('Detector.mat');

vidReader = VideoReader('gun.mp4');
vidPlayer = vision.DeployableVideoPlayer;
i = 1;
results = struct('Boxes',[],'scores',[]);

while(hasFrame(vidReader))
    I = readFrame(vidReader);
    [bboxes,scores] = detect(detector,I,'threshold',1);
   
    [~,idx] = max(scores);
    results(i).Boxes = bboxes;
    results(i).Scores = scores;
    
    annotation = sprintf('%s, Confidence %4.2f',detector.ModelName,scores(idx));
    I = insertObjectAnnotation(I,'rectangle',bboxes(idx,:),annotation);

    step(vidPlayer,I);

    i = i+1;
end
results = struct2table(results);
release(vidPlayer);
