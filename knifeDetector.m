load('DetectorKnife.mat');
load('DetectorGun.mat');

A = uigetfile('fileSelector','fileExtention','.mp4');
vidReader = VideoReader(A);
vidPlayer = vision.DeployableVideoPlayer;
i = 1;
results = struct('Boxes',[],'scores',[]);

result = struct('Box',[],'score',[]);


while(hasFrame(vidReader))
    I = readFrame(vidReader);
    [bboxes,scores] = detect(detectorKnife,I,'threshold',1);
        [bbox,score] = detect(detectorGun,I,'threshold',1);

   
    [~,idx] = max(scores);
    results(i).Boxes = bboxes;
    results(i).Scores = scores;
    
    [~,ids] = max(score);
    results(i).Box = bbox;
    results(i).Score = score;
    
    annotation = sprintf('%s, Confidence %.2f',detectorKnife.ModelName,scores(idx));
    I = insertObjectAnnotation(I,'rectangle',bboxes(idx,:),annotation);
    
    Annotation = sprintf('%s, Confidence %4.2f',detectorGun.ModelName,score(ids));
    I = insertObjectAnnotation(I,'rectangle',bbox(ids,:),Annotation);

    step(vidPlayer,I);
  if(score(ids)>=80)
        fprintf('gun detected\n');
  end
  if(scores(idx)>=80)
        fprintf('knife detected\n');
  end
    i = i+1;
end
results = struct2table(results);

result = struct2table(result);

release(vidPlayer);

