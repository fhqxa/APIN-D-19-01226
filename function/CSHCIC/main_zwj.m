clear;clc;
  load DD;
%  load Cifar4096dTest
%    load Protein194; 
%  load Sun324Train;%%四层结构，树结构完整，分布不均匀
%  load ILSVRC57Test;
% load CompCar1342Test;%%四层结构，树结构完整，但数据分布均匀%%596类没有样本
% load AWAphog10;
% load VOC20Test;%%，五层，同上
% load Car196Train;%%三层，分布不那么均匀，增加0.0043

numFolds = 10;



tic
[accuracyMean,tieMean] = Kflod_TopDownClassifier(data_array,numFolds,tree);
 t=toc;