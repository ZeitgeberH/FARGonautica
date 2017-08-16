function ps = setps()

%tipos de estruturas a serem consideradas!! voce pr�-escolhe!!
ps.structures = {'partition', 'chain', 'order', 'ring', 'hierarchy',...
			 'tree', 'grid', 'cylinder',...
    'partitionnoself',...
    'dirchain', 'dirchainnoself', 'undirchain', 'undirchainnoself',...
    'ordernoself', 'connected', 'connectednoself',...  
    'dirring', 'dirringnoself', 'undirring', 'undirringnoself',...
    'dirhierarchy', 'dirhierarchynoself', 'undirhierarchy', 'undirhierarchynoself',...
    };

% nomes dos datasets
ps.data	      = {'demo_chain_feat', 'demo_ring_feat',...
		 'demo_tree_feat', 'demo_ring_rel_bin',...
		 'demo_hierarchy_rel_bin', 'demo_order_rel_freq',...
		 'synthpartition', 'synthchain', 'synthring',...
		 'synthtree', 'synthgrid', 'animals',...
		 'judges', 'colors', 'faces', 'cities',...
		 'mangabeys','bushcabinet', 'kularing',...
		 'prisoners','schools', 'ft2010N'};

ps.repeats    = ones(1,length(ps.data));

% locations of data files

b = [pwd, '/data/']; 

ps.dlocs      = {[b, 'demo_chain_feat'], [b, 'demo_ring_feat'],...
		 [b, 'demo_tree_feat'], [b, 'demo_ring_rel_bin'],...
		 [b, 'demo_hierarchy_rel_bin'], [b, 'demo_order_rel_freq'],...
		 [b, 'synthpartition'], [b, 'synthchain'], [b, 'synthring'],...
		 [b, 'synthtree'], [b, 'synthgrid'], [b, 'animals'],...
		 [b, 'judges'], [b, 'colors'], [b, 'faces'], [b, 'cities'],...
		 [b, 'mangabeys'], [b, 'bushcabinet'], [b, 'kularing'],...
		 [b, 'prisoners'], [b, 'schools'], [b, 'ft2010N']};

% Effective number of features for Similarity data
ps.simdim = {};
for i=1:length(ps.data)
  ps.simdim{i} = 1000;
end

