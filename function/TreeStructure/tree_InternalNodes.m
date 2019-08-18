%% Return the index of the middle node.
%% Author: Hong Zhao
%% Date: 2016-5-14
%% Modify: Qianjuan Tuo
%% Date: 2017-5-27
%% Example:
% load tree;
% return internal nodes and root node
% middleNode = tree_InternalNode( tree )
function [ middleNode ] = tree_InternalNodes( tree )
treeParent=tree(:,1)';
index=find(treeParent==0);
Allnonleaf=unique(treeParent);
middleNode=setdiff(Allnonleaf,0);
middleNode(find(middleNode==index))=[];
middleNode=middleNode';


