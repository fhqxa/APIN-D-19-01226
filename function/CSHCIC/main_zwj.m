clear;clc;
  load DD;
%  load Cifar4096dTest
%    load Protein194; 
%  load Sun324Train;%%�Ĳ�ṹ�����ṹ�������ֲ�������
%  load ILSVRC57Test;
% load CompCar1342Test;%%�Ĳ�ṹ�����ṹ�����������ݷֲ�����%%596��û������
% load AWAphog10;
% load VOC20Test;%%����㣬ͬ��
% load Car196Train;%%���㣬�ֲ�����ô���ȣ�����0.0043

numFolds = 10;



tic
[accuracyMean,tieMean] = Kflod_TopDownClassifier(data_array,numFolds,tree);
 t=toc;