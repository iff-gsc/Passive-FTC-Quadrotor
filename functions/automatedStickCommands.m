function simin = automatedStickCommands( )

% fly 5m square after 5s
simin.time                  = [ 0, 5:2.5:(5+2.5*8) ]';
simin.signals.values        = zeros( 4, 10 )';
simin.signals.values(:,1)   = [ 0, 1, 0, 0, 0, -1, 0, 0, 0, 0 ]'*0.292;
simin.signals.values(:,2)   = [ 0, 0, 0, -1, 0, 0, 0, 1, 0, 0 ]'*0.292;
simin.signals.dimensions    = 4;

end