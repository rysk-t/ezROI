function mask = makeRoundMask(center, radi, imSize)

[X, Y] = meshgrid(1:imSize(2), 1:imSize(1));
Z = (X - center(1)).^2 + (Y- center(2)).^2;
Z(Z<radi^2) = 1;
Z(Z~=1) = 0;
mask = Z;
