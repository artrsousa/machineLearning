function show(image, labels, colors)
  titles = {};
  % Percorre as labels, pega a cor correspondente
  % e cria o tÃ­tulo;

%   for i=1:size(labels, 1)
%     r = num2str(colors(i,1)/255); % red
%     g = num2str(colors(i,2)/255); % green
%     b = num2str(colors(i,3)/255); % blue
%     titles{i} = [
%       '\color[rgb]{',r,',',g,',',b,'}',labels{i,1}
%     ];
%   end

  figure; imshow(image);
  imlegend(colors, labels);
end

function imlegend(colorArr, labelsArr)
% For instance if two legend entries are needed:
% colorArr =
%   Nx3 array of doubles. Each entry should be an RGB percentage value between 0 and 1
%
% labelsArr =
%   1×N cell array
%     {'First name here'}    {'Second name here'}    {'etc'}
hold on;
for ii = 1:length(labelsArr)
  % Make a new legend entry for each label. 'color' contains a 0->255 RGB triplet
  scatter([],[],1, colorArr(ii,:), 'filled', 'DisplayName', labelsArr{ii});
end
hold off;
legend('Location','northeastoutside');
end
