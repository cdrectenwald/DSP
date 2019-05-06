%% Chris Rectenwald, DSP, Project 3

%% Files 
% /Users/Cdrectenwald/Downloads/woman.tif woman
% /Users/Cdrectenwald/Downloads/lena.tif
% /Users/Cdrectenwald/Downloads/headCT.tif
% /Users/Cdrectenwald/Downloads/crowd.tif
% /Users/Cdrectenwald/Downloads/beans.tif
% /Users/Cdrectenwald/Downloads/beans.tif
% /Users/Cdrectenwald/Downloads/barbara.tif 



%% Read file 
A= imread('/Users/Cdrectenwald/Downloads/barbara.tif');
%A= im2double(A);
figure(1);
imshow(A)
title('Original image')

%% Quantize (Part A)
B = 2; %bits per pixel
level= 2^B;
%thresh= multithresh(A,level-1);
%valuesMax= [thresh max(A(:))];
%valuesMin =[min(A(:)) thresh];

D=A;
Original=A;
Original= double(A);
[j,l]= size(A);
switch(B)
    case(4)
    thresh= [17, 34, 51, 68, 85, 102, 119, 136,153, 170, 187, 204, 221, 238, 255]; 
for i=1:j
    for k=1:l
        if (A(i,k) >= thresh(1) && A(i,k) < thresh(2))
            A(i,k) = thresh(1);
        elseif (A(i,k) >= thresh(2) && A(i,k) < thresh(3))
            A(i,k) = thresh(2);
        elseif (A(i,k) >= thresh(3) && A(i,k) < thresh(4))
            A(i,k)= thresh(3);
        elseif (A(i,k) >= thresh(4) && A(i,k) < thresh(5))
            A(i,k)= thresh(4);
        elseif (A(i,k) >= thresh(5) && A(i,k) < thresh(6))
            A(i,k)= thresh(5);
        elseif (A(i,k) >= thresh(6) && A(i,k) < thresh(7))
            A(i,k)= thresh(6); 
        elseif (A(i,k) >= thresh(7) && A(i,k) < thresh(8))
            A(i,k)= thresh(7);
        elseif (A(i,k) >= thresh(8) && A(i,k) < thresh(9))
            A(i,k)= thresh(8);
        elseif (A(i,k) >= thresh(9) && A(i,k) < thresh(10))
            A(i,k)= thresh(9);    
        elseif (A(i,k) >= thresh(10) && A(i,k) < thresh(11))
            A(i,k)= thresh(10); 
        elseif (A(i,k) >= thresh(11) && A(i,k) < thresh(12))
            A(i,k)= thresh(11); 
        elseif (A(i,k) >= thresh(12) && A(i,k) < thresh(13))
            A(i,k)= thresh(12); 
        elseif (A(i,k) >= thresh(13) && A(i,k) < thresh(14))
            A(i,k)= thresh(13); 
        elseif (A(i,k) >= thresh(14) && A(i,k) < thresh(15))
            A(i,k)= thresh(14); 
        elseif (A(i,k) >= thresh(15))
            A(i,k)= thresh(15); 
        else 
            A(i,k) = 0;
        end
    end 
end 

    case(2)
        thresh= [85, 170, 255];
 for i=1:j
    for k=1:l
        if (A(i,k) >= thresh(1) && A(i,k) < thresh(2))
            A(i,k) = thresh(1);
        elseif (A(i,k) >= thresh(2) &&  A(i,k) < thresh(3))
            A(i,k) = thresh(2);
        elseif (A(i,k) >= thresh(3))
            A(i,k) = thresh(3);
        else
            A(i,k) = 0;
        end
    end 
 end 
 
end
figure(2);
imshow(A)
title('Quantized image');
Quant_A=A;

%% Part 2 implement a laplacian operator 
h = [.18, .17, .08;
    .17, -1, .17;
    .08, .17, .08];

B= conv2((D),(h)); %original 
E= conv2(Quant_A,h);

figure(3)
imshow(B,[min(min(B))+10 max(max(B))-10])
title('Part : Original image conv2() with h')
figure(4)
imshow(E,[min(min(E))+10 max(max(E))-10])
title('Part 2 quantized image conv2() with h');

%% part 3
% create a 2D high pass filter
F=[0 .6 .7 1]; % normalized frequency
Amp=[1.0, 1.0, 4.0, 4.0]; %gain
W= [1.0, 1.0]; %Weights of each band
n= 26;
b1= firpm(n,F,Amp,W);
l=[0:length(b1)-1];
b2= b1.';
Hp = b2*b1;

Hp2= [0, 0 , 0, 0 ,0;
   0,0, -1, 0,0;
   0,-1, 5, -1,0;
   0,0, -1 , 0,0;
   0, 0 , 0, 0 ,0;];
[Hp1, Hp3] = lu(Hp2);
figure(4)
stem(b1,l)

freqz(b1,1,256);
D= conv2(double(Original), double(Hp));
max_D= max(max(D));
D= D/max_D;
D= D*255;
figure(5)
imshow(D, [0 255])
imwrite(D, '.tif');
title('Part 3: Quantized image high pass filter');




%% Part 4
% implement filter from 4.116a
%h0
h0 = [.5, .5];
E= conv2(Original, h0);
figure(6)
imshow(E, [0 255]);
title('Part 4: Original Image through h0 filter');
%h1

h1= [.5, -.5];
F= conv2(Original,h1);
figure(7)
imshow(F, [min(min(F))+10, max(max(F))-10]);
title('Part 4: Original image through h1')
% g0 
g0= 2*h0;
G= conv2(Original, g0);
maxG= max(max(G));
figure(8)
title('Part 4: Original image through g0')
%g1 
g1= -2*h1;
H= conv2(Original,g1);

figure(9);
imshow(H, [0 255]);
title('Part 4: Original image through g1')


%% part 5


% create vectors for h
h00= (h0.')*h0;
h01= (h0.')*h1;
h10=  (h1.')*h0;
h11= (h1.')*h1;
% create vectors for g

g00= (g0.')*(g0);
g01= (g0.')*(g1);
g10= (g1.')*(g0);
g11= (g1.')*(g1);


% create subband filters
H00= (conv2(h00, Original));
figure(10)
imshow(H00, [min(min(H00))+10 max(max(H00))-10])
title('Part 5: with Original image h00 filter')

H01= conv2(Original,h01);
figure(11)
imshow(H01,  [min(min(H01))+10 max(max(H01))-10])
title('Part 5: h01 filter on original image')

H11= conv2(h11, Original);
figure(12)
imshow(H11,  [min(min(H11))+10 max(max(H11))-10])
title('Part 5: h11 filter with Original')

H10= conv2(h10, Original);
figure(13)
imshow(H10, [min(min(H10))+10 max(max(H10))-10])
title('Part 5: h10 filter with Original')

% down_sample by 2 



DownH01= H01(1:2:end, 1:2:end);
figure(22)
imshow(DownH01, [min(min(DownH01))+10 max(max(DownH01))-10])
title('Downsampled original image with h01')

DownH00= H00(1:2:end, 1:2:end);
figure(23)
imshow(DownH00, [min(min(DownH00))+10 max(max(DownH00))-10])
title('Part 5: Downsampled by 2 h00')

DownH10= H10(1:2:end, 1:2:end);
figure(24)
imshow(DownH10, [min(min(DownH10))+10 max(max(DownH10))-10])
title('Part 5: Downsampled by 2 h10')

DownH11= H11(1:2:end, 1:2:end);
figure(25)
imshow(DownH11, [min(min(DownH11))+10 max(max(DownH11))-10])
title('Part 5: Downsampled by 2 h11')

% Make matrix twice as big as downsampled 
[X,Y]= size(DownH11);
up_h00= zeros(2*X,2*Y);
up_h01= zeros(2*X,2*Y);
up_h10= zeros(2*X,2*Y);
up_h11= zeros(2*X,2*Y);

%Create upsampled matrices
up_h00(1:2:end,1:2:end)= DownH00;
up_h10(1:2:end,1:2:end)= DownH10;
up_h01(1:2:end,1:2:end)= DownH01;
up_h11(1:2:end,1:2:end)= DownH11;

%% Part 6, upsampling and synthesis

%pass through each synthesis filter
result_h01= conv2(up_h01, g01);
result_h11= conv2(up_h11, g11);
result_h10= conv2(up_h10, g10);
result_h00= conv2(up_h00, g00);

final_result = double(result_h00) + double(result_h01)+ double(result_h10) + double(result_h11);
figure(30)
imshow(final_result, [0 255])
title('Reassembled image')
final_result= final_result(2:end-2 , 2:end-2);
imshow(final_result, [min(min(final_result))+10 max(max(final_result))-10])


[X,Y]= size(final_result);
error= double(Original)-double(final_result);
max_error= max(max(error));
final_result_max= max(max(final_result));