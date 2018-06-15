function [Plastic_window, Pop] = FindYieldStart(Stress, Strain, end_segment, E_ind, Plastic)

% finds the first data point in the back extrapolation yield point and
% hardening calculation
% this is either the intersection of a strain offset value or the first
% point after a pop-in event defined with a threshold strain jump
% end_segment is the last point of the elastic data

% in case a pop-in is detected in between the end of the elastic data and
% the actual pop-in, adjust end_segment to start the search further
% along??????????why????????
% end_segment = end_segment+50;

Plastic_window.max_point = NaN;
Plastic_window.min_point = NaN;
Plastic_window.popsuccess = NaN;
Plastic_window.Hsuccess = NaN;

Pop.Stress = NaN;
Pop.Strain = NaN;
Pop.index = NaN;

end_search = length(Strain) - Plastic.smooth_window; % limit search so that smoothstrain.m will not give errors
pop_window = Plastic.pop_window;
change = Strain(end_segment+pop_window:end_search) - Strain(end_segment:end_search-pop_window); % change in strain between n+3 and n
%???????why 'change' is not set as an absolute value?????

% change has the same indexing as Strain only without the last three points
pindex = find(change > Plastic.pop_in, 1); %pop-in threshold, first occurence, pindex is the first point, n, in the pop-in from n:n+3
popsuccess = isempty(pindex);
Plastic_window.popsuccess = popsuccess; 

if popsuccess==0 % pop-in detected
    stress_index = pindex -1 + end_segment;
    Pop.index = [stress_index:stress_index+pop_window];
    Pop.Stress = Stress(Pop.index);
    Pop.Strain = Strain(Pop.index);
    [y, k] = min(Stress(stress_index:end_search)); % find the minimum stress after the pop-in, can limit the search to right after the pop-in
    min_stress_index = k -1 + stress_index; % put the index back to the same indexing as Stress
    % C_dstrain default is 1/3
    % C_dstrain = 0, starts fit immediately after the popin
    % C_dstrain = 1, starts fit as soon as the strain is greater than the
    % strain at the pop-in cliff
    dstrain = Plastic.C_dstrain * (Strain(stress_index + pop_window) - Strain(min_stress_index));

    % % ?????????    % dstrain is the distance in strain from the last point of the
% %     % pop-in to the start of the back extrapolation and hardening fit.
% %     % the initial recovery after a pop-in is very high, we want to minimize
% %     % this effect on the back extrapolated slope by not starting the fit at
% %     % the pop-in valley.
    mind_point = find(Strain(min_stress_index:end_search) > (Strain(stress_index + pop_window) - dstrain), 1); % start of back extrapolation fit
    min_point = mind_point -1 + min_stress_index; % put the indexing back to the same as Stress and Strain
else
    % use offset strain to find the start of the hardening fit
    % Plastic.YS_offset default is 0.002
    f1 = E_ind .* (Strain(end_segment:end_search) - Plastic.YS_offset); % offset line using modulus slope
    mind_point = find ( (f1 - Stress(end_segment:end_search)) > 0, 1 ); % first point after the offset line
    min_point = mind_point -1 + end_segment; % put the indexing back to the same as Stress and Strain
end

% finds the last data point based on another offset strain
f2 = E_ind .* (Strain(end_segment:end_search) - Plastic.H_offset); % offset line using modulus slope
i2 = find ( (f2 - Stress(end_segment:end_search)) > 0, 1 ); % first point after the offset line
success_i2 = isempty(i2);
Plastic_window.Hsuccess = success_i2; % indicates whether there is enough data to reach the specifed offset

if success_i2 == 0; % there is enough data
    max_point = i2 -1 + end_segment; % end of back extrapolation/hardening fit
else % not enough data
    max_point = end_search; % end of data
end

Plastic_window.max_point = max_point;
Plastic_window.min_point = min_point;

end