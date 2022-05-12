function num = b64decode(c)
if c == '+'
    num = 62;
elseif c == '/'
    num = 63;
elseif c < 'Z'
    num = c - 'A';
elseif c < 'z'
    num = c - 'a' + 26;
else
    num = c - '0' + 52;
end
end
