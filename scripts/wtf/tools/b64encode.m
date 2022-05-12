function c = b64encode(num)
if num < 26
    c = char('A' + num);
elseif num < 52
    c = char('a' + num - 26);
elseif num < 62
    c = char('0' + num - 52);
elseif num == 62
    c = '+';
else
    c = '/';
end 
end