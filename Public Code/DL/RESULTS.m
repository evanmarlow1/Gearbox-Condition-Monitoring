% This script just plots results of the DL_V3 model with different sample lengths.


SampleLengthsBinary = [3 5 7 10 15 25 40];

TestAccuraciesBinary = [80.00 90.40 79.29 90.40 86.93 84.64 81.75];

SampleLengthsMulti = [3 5 10 15 25];

TestAccuraciesMulti = [73.00 79.40 73.33 73.13 78.08];

SampleLengthsBinaryAlex = [10 25 40];
SampleLengthsMultiAlex = [10 25];

TestAccuraciesBinaryAlex = [80.96 80.72 80.07];
TestAccuraciesMultiAlex = [70.1 72];

SampleLengthsBinaryGoogle = [15 25 40];
TestAccuraciesBinaryGoogle = [84.47 90.60 84.13];

%%

figure;
plot(SampleLengthsMulti,TestAccuraciesMulti,'rx--','LineWidth',2)
hold on
plot(SampleLengthsBinary,TestAccuraciesBinary,'bx--','LineWidth',2)
plot(SampleLengthsBinaryAlex,TestAccuraciesBinaryAlex,'gx--','LineWidth',2)
plot(SampleLengthsMultiAlex,TestAccuraciesMultiAlex,'x--','LineWidth',2)
plot(SampleLengthsBinaryGoogle,TestAccuraciesBinaryGoogle,'x--','LineWidth',2,'MarkerSize',10)
legend('Multi-Class - SqueezeNet','Binary - SqueezeNet','Binary - AlexNet','Multi-Class - AlexNet','Binary - GoogLeNet','FontSize', 20)
xlabel('Number of samples per signal')
ylabel('Test Accuracy')
title('Paderborn Results')
set(gca,'FontSize',20)
ylim([60 100])
grid on
