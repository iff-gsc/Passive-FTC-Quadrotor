function yq = interpHold( x, y, xq )
% interpHold required by Simulink block "automated stick inputs from
% workspace"

len = size(x,1);

[~,idx] = max(x>xq);

idx = idx-1;

idx = max( 1, min( len, idx ) );

yq = y(idx,:);

end