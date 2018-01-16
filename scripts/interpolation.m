% n linear interpolation of vector
function ret=interpolation(vec,n)
ret=[];
for i=1:n-1
    ret(i)=0;
end
for i=n:(length(vec)*n)
    if mod(i,n)==0
        ret(i)=vec(i/n);
        continue;
    end
    for j=1:(n-1)
        if mod(i,n)==j
            ret(i)=(vec((i-j)/n)*(n-j)+vec((i+n-j)/n)*j)/n;
            break;
        end
    end
end
ret=ret';
