load('DetectorGun.mat');

vidReader = VideoReader('gun.mp4');
vidPlayer = vision.DeployableVideoPlayer;
vidReader.CurrentTime = 0;
i = 1;
results = struct('Boxes',[],'scores',[]);

while(hasFrame(vidReader))
    I = readFrame(vidReader);
    [bboxes,scores] = detect(detectorGun,I,'threshold',1);
   
    [~,idx] = max(scores);
    results(i).Boxes = bboxes;
    results(i).Scores = scores;
    
    annotation = sprintf('%s, Confidence %4.2f',detectorGun.ModelName,scores(idx));
    I = insertObjectAnnotation(I,'rectangle',bboxes(idx,:),annotation);
    
    pause(0.1/vidReader.FrameRate)

    step(vidPlayer,I);
i = i+1;
end    

results = struct2table(results);
release(vidPlayer);
