%% %%%%%%%----------------------------Demo---------------------------------%%%%%%%
load('gTruthTraining.mat')

demoGTruth = selectLabels(gTruth,'gun');

% if isfolder(fullfile('TrainingData'))
%     cd TrainingData
% else
%     mkdir TrainingData
% end
addpath('TrainingData');

trainingData = objectDetectorTrainingData(demoGTruth,'samplingFactor',2,...
    'WriteLocation','TrainingData');

detector = trainACFObjectDetector(trainingData,'NumStages',5);

save('Detector.mat','detector');
rmpath('TrainingData');



%% %%%%%%%----------------------------Knife---------------------------------%%%%%%%
load('knife.mat')

knifeGTruth = selectLabels(knife,'knife');

% if isfolder(fullfile('TrainingData'))
%     cd TrainingData
% else
%     mkdir TrainingData
% end
addpath('TrainingDataKnife');

trainingData = objectDetectorTrainingData(knifeGTruth,'samplingFactor',2,...
    'WriteLocation','TrainingDataKnife');

detectorKnife = trainACFObjectDetector(trainingData,'NumStages',5);

save('DetectorKnife.mat','detectorKnife');
rmpath('TrainingDataKnife');



%% %%%%%%%----------------------------Gun---------------------------------%%%%%%%

load('gun.mat')

gunGTruth = selectLabels(gun,'gun');

% if isfolder(fullfile('TrainingData'))
%     cd TrainingData
% else
%     mkdir TrainingData
% end
addpath('TrainingDataGun');

trainingData = objectDetectorTrainingData(gunGTruth,'samplingFactor',2,...
    'WriteLocation','TrainingDataGun');

detectorGun = trainACFObjectDetector(trainingData,'NumStages',5);

save('DetectorGun.mat','detectorGun');
rmpath('TrainingDataGun');


