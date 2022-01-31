%% Animate 3D NIPS 2015 Graph

figure                                                          % new figure
colormap cool                                                   % use cool colormap
msize = 10*(outdegree(G) + 3)./max(outdegree(G));               % marker size
ncol = outdegree(G) + 3;                                        % node colors
named = outdegree(G) > 7;                                       % nodes to label
h = plot(G, 'MarkerSize', msize, 'NodeCData', ncol);            % plot graph
layout(h,'force3','Iterations',30)                              % change layout
labelnode(h, find(named), G.Nodes.Name(named));                 % add node labels
axis vis3d off                                                  % set axis
set(gca,'clipping','off')                                       % turn off clipping
zoom(1.5)                                                       % zoom in
set(gca,'cameraviewanglemode','manual');                        % fix zoom
filename = 'html/nips2015.gif';                                 % gif file
delay = 0.1;                                                    % 10 frame per second

first = true;                                                   % flag
[~,el] = view;                                                  % get el
for k = 0:360                                                   % loop
    view(k,el)                                                  % update view
    pause(0.1)                                                  % pause 0.1 sec
    set(gcf,'color','w');                                       % set background to white
    fname = getframe(gcf);                                      % get the frame
    [x,cmap] = rgb2ind(fname.cdata, 128);                       % get indexed image
    if first                                                    % if first frame
        first = false;                                          % update flag
        imwrite(x,cmap, filename, ...                           % save as GIF
            'Loopcount', Inf, ...                               % loop animation
            'DelayTime', delay);                                % set delay
    else                                                        % if image exists
        imwrite(x,cmap, filename, ...                           % append frame
            'WriteMode', 'append', 'DelayTime', delay);         % to the image
    end
end