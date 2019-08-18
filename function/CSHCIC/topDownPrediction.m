%% Top-down prediction
% Written by Yu Wang
% Modified by Hong Zhao
% 2017-4-11
%% Inputs:
% input_data: training data without labels
% model:
% tree: the tree hierarchy
% 计算单条路线
%% Output

function [predict_label] = topDownPrediction(input_data,input_label, model, tree, train_num)
input_label_Parent = tree(input_label);
levelone_nodes=find(tree(:,2)==1);%%第二层的子节点
train_distribute=train_num(:,2);%data distribution of leaf nodes in the training set
train_num(:,1)=tree(train_num(:,1));

leaf_level=max(tree(:,2));
max_leaf=max(find(tree(:,2)==leaf_level));

if leaf_level >2 
    [b,~]=size(find(tree(:,2)==2));
    leveltwo_nodes=find(tree(:,2)==2);
    for i=1:b
        num_leveltwo_nodes(i)=sum(train_distribute(model{leveltwo_nodes(i)}.Label));
    end
    num_leveltwo_nodes(2,:)=tree(leveltwo_nodes,1);
    num_leveltwo_nodes=num_leveltwo_nodes';
    temp_num_leveltwo_nodes=num_leveltwo_nodes;
    [n,~]=size(find(tree(:,2)==1));
    for i=1:n
        num_levelone_nodes(i)=sum(num_leveltwo_nodes(model{levelone_nodes(i)}.Label-max_leaf));
    end
end
   
 root = find(tree(:,1)==0);


[n,~]=size(find(tree(:,2)==1));
if leaf_level==2 
for i=1:n
    num_levelone_nodes(i)=sum(train_distribute(model{levelone_nodes(i)}.Label));%data distribution of internal nodes  
end
end

root_label=model{root}.Label;
num_sort_root=sort(root_label);
[n,~]=size(model{root}.Label);
for i=1:n;
    sort_root_label(i)=find(num_sort_root==root_label(i));
end


num_levelone_nodes=num_levelone_nodes(sort_root_label);%the distribution of intermediate nodes according to the Label of model{root}

[m,~]=size(input_data);
for j=1:m%The number of samples
    %% 先从树根开始
    
    [~,~,d_v] = predict(1,sparse(input_data(j,:)), model{root}, '-b 1 -q');%the first argument doesn't work
    
    
    if(max(d_v)>0.55)
        [~,currentNodeID] = max(d_v);
    else
        d_v = d_v./(sqrt(num_levelone_nodes)+1);
        [~,currentNodeID] = max(d_v);
    end
    
%     [~,currentNodeID] = max(d_v);
    
    currentNode=model{root}.Label(currentNodeID);
if leaf_level >2
    num_leveltwo_nodes=temp_num_leveltwo_nodes;
    num_leveltwo_nodes=num_leveltwo_nodes(find(num_leveltwo_nodes(:,2)==currentNode),:);
    num_leveltwo_nodes(:,2)=find(tree(:,1)==currentNode);
    num_leveltwo_nodes(:,3)=model{currentNode}.Label;
    [n,~]=size(num_leveltwo_nodes);
    for i=1:n
        num_leveltwo_nodes(i,4)=find(num_leveltwo_nodes(:,2)==num_leveltwo_nodes(i,3));
    end   
    nnum_leveltwo_nodes=num_leveltwo_nodes(:,1);%%%the distribution of leaf nodes according to the Label of model{currentNode}
    nnum_leveltwo_nodes=nnum_leveltwo_nodes(num_leveltwo_nodes(:,4));
    nnum_leveltwo_nodes=nnum_leveltwo_nodes';
    [~,~,d_v] = predict(1,sparse(input_data(j,:)),model{currentNode}, '-b 1 -q');
    
    
       if(max(d_v)>0.55)
        [~,currentNodeID] = max(d_v);
    else
        d_v = d_v./(sqrt(nnum_leveltwo_nodes)+1);
        [~,currentNodeID] = max(d_v);
    end
%      [~,currentNodeID] = max(d_v);
    currentNode=model{currentNode}.Label(currentNodeID);
    
end
    
    
    %% 递归调用中间层直到叶子结点
    num_leafnodes=train_num(find(train_num(:,1)==currentNode),:);
    num_leafnodes(:,1)=find(train_num(:,1)==currentNode);
    num_leafnodes(:,3)=model{currentNode}.Label;
    [n,~]=size(num_leafnodes);
    for i=1:n
        num_leafnodes(i,4)=find(num_leafnodes(:,1)==num_leafnodes(i,3));
    end   
    nnum_leafnodes=num_leafnodes(:,2);%%%the distribution of leaf nodes according to the Label of model{currentNode}
    nnum_leafnodes=nnum_leafnodes(num_leafnodes(:,4));
    while(~ismember(currentNode,tree_LeafNode(tree)))
        [~,~,d_v] = predict(1,sparse(input_data(j,:)),model{currentNode}, '-b 1 -q');

      
        %%%%%%%%%%%%%%%0.7694%%%这里的+3和+rate_childnodes效果差不多
        
        if(max(d_v)>0.55)
         [~,currentNodeID] = max(d_v);
    else
        d_v = d_v./(sqrt(nnum_leafnodes)+1)';
        [~,currentNodeID] = max(d_v);
    end

%          [~,currentNodeID] = max(d_v);
         currentNode=model{currentNode}.Label(currentNodeID);
    end
    predict_label(j)=currentNode;
end %%endfor

end
