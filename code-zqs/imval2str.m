function dig = imval2str(style, i)
len = length(style);
i = num2str(i);
dig = [style(1:(len-length(i))), i];
end
