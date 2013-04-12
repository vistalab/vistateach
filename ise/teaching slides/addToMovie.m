function M = addToMovie(M,img,copies)

last = size(M);
for ii=1:copies
    M(last+ii) = im2frame(img);
end

return
