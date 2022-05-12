function note = generate_piano_note(f, pianod, relx)
%% parameters
fs = 44100;
dt = 1 / fs;
dte = pianod.td(1) * relx;

%% build time vector
N = round(dte * (length(pianod.td) + 1) / dt);
t = ([1:N])' * dt;
y = 0;

%% build harmony wave
for ifh = 1:size(pianod.hl, 2)
    ints = func_interp1(pianod.td * relx, abs(pianod.hl(:, ifh)), t);
    yh = ints .* sin(2 * pi * ifh * f * t);
    y = y + yh;
end

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
