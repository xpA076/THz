function note = generate_piano_note(f, pianod)
%% parameters
relaxation_factor = 1;
% y_add = [];
% % if nargin > 2
% %     relaxation_factor = vargin{1};
% % end
% if nargin > 3
%     y_add = vargin{2};
% end

fs = 44100;
dt = 1 / fs;
dte = pianod.td(1) * relaxation_factor;
% Nw = round(dte / dt * 3);

%% build time vector
% N = floor(max(pianod.te) / dt);
% t = ([1:N])' * dt;
% y = zeros(N, 1);
% Npad = Nw;
% y = zeros(Npad + ceil(pianod.td(end) / dt) + Npad, 1);
N = round(dte * (length(pianod.td) + 1) / dt);
t = ([1:N])' * dt;
y = 0;

%% build harmony wave
for ifh = 1:size(pianod.hl, 2)
    ints = func_interp1(pianod.td, abs(pianod.hl(:, ifh)), t);
    yh = ints .* sin(2 * pi * ifh * f * t);
    y = y + yh;
end

% % it1 = 1;
% for i = 1:size(pianod.hl, 1)
%     t_span = ([1:Nw])' * dt;
%     y_span = 0;
%     for ifh = 1:size(pianod.hl, 2)
%         y_span = y_span + abs(pianod.hl(i, ifh)) * ...
%             sin(2 * pi * (ifh * f * t_span + 0 * rand()));
%     end
%     y_span = y_span .* hamming(Nw);
%     i_center = round(i * dte / dt) + Npad;
%     i1 = i_center - round(Nw / 2);
%     y(i1:i1 + Nw - 1) = y(i1:i1 + Nw - 1) + y_span;
%     
% 
% %     it = round(i * dte / dt);
% % %     it1 = it - round(dte / dt);
% %     it2 = it + round(dte / dt / 2);
% %     % additional phase for base frequency
% %     phi = zeros(1, size(pianod.hl, 2));
% %     if i > 1
% %         phi(1) = asin(y(end) / abs(pianod.hl(i, 1)));
% % %         angle(y(end)) + 2 * pi * f * dt;
% %     end
% %     % build istft part
% %     is_span_ok = 0;
% %     while is_span_ok == 0
% %         t_span = ([1:(it2 - it1 + 1)] * dt)';
% %         y_span = 0;
% %         for ifh = 1:size(pianod.hl, 2)
% %             y_span = y_span + abs(pianod.hl(i, ifh)) * ...
% %                 sin(2 * pi * (ifh * f * t_span) + phi(ifh));
% %         end
% %         % make sure for a smooth transition
% %         a =abs(y_span(end) / abs(pianod.hl(i, 1))); 
% %         if abs(y_span(end) / abs(pianod.hl(i, 1))) > 0.8
% %             % shift for addition 1/4 base frequency cycle
% %             it2 = it2 + round(1 / f / 4 / dt);
% %         else
% %             y = [y; real(y_span)];
% %             it1 = it2 + 1;
% %             is_span_ok = 1;
% %         end
% %     end
% end
% y = y(Npad + 1:end);
% y = y(2:end);
% y = real(y);
% [tes, yes] = find_envelope(y);
% ye_ratio = ismtd.ye./yes;

% %% build envelope
% ye_ext = ismtd.te;
% mult_top = interp1(ismtd.te, ismtd.ye(1, :), t);
% mult_bot = interp1(ismtd.te, ismtd.ye(2, :), t);
% % plot(t, [mult_top; mult_bot])
% 
% %% build note
% i_top = find(y > 0);
% y(i_top) = y(i_top) .* mult_top(i_top);
% i_bot = find(y < 0);
% y(i_bot) = -y(i_bot) .* mult_bot(i_bot);

% y = y .* mult_top;
y(1:length(pianod.y_add)) = y(1:length(pianod.y_add)) + pianod.y_add;
note = y / max(y);
end

% every input is incremental
function val = func_interp1(X, V, Xq)
i_left = find(Xq < X(1));
il = i_left(end);
i_right = find(Xq > X(end));
ir = i_right(1);
val = zeros(size(Xq, 1), size(Xq, 2));
% left
val(1:il) = (V(1) - 0) / (X(1) - 0) * (Xq(1:il) - 0) + 0;
% middle
val(il + 1:ir - 1) = interp1(X, V, Xq(il + 1:ir - 1));
% right
val(ir:end) = (V(end) - V(end - 1)) / (X(end) - X(end - 1)) * ...
    (Xq(ir:end) - X(end)) + V(end);
end
