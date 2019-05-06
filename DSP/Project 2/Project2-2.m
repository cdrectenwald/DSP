%% Chris Rectenwald, DSP, Project 2
clear csc
clear
%% Files from DSP website
%fileA = '/Users/Cdrectenwald/Desktop/DSP/Project 2/num1n0.0dt0.0'; 
%fileB ='/Users/Cdrectenwald/Desktop/DSP/Project 2/num2n0.0dt0.0';
%fileB ='/Users/Cdrectenwald/Desktop/DSP/Project 2/n1.0dt2.0'; dial tone
%fileB ='/Users/Cdrectenwald/Desktop/DSP/Project 2/n2.0dt0.0'; super noisy
%fileB ='/Users/Cdrectenwald/Desktop/DSP/Project 2/n1.0dt0.0'; some noise

%% Intiliaze
fs= 8192; % Hz, sampling frequency
Nyquist= fs/2;
Period= 1/fs;
%f1= [697, 770, 852, 941]; %low frequency group
%f2= [1209, 1336, 1477]; %high frequency group
t= .05; %duration of signal (s)
key= '';
%% Prompt User
prompt= 'Enter a filename or say exit or q to quit program ';
filename= input(prompt, 's');
s1= 'exit';
s2= 'q';
tf1= strcmpi(s1,filename);
tf2= strcmpi(s2,filename);
while (tf2 == 0 && tf1 == 0)
%% Recieve file
fileID= fopen(filename, 'r');
A = fread(fileID, inf, 'float');
fclose(fileID);
n= length(A);
%% iterate through each row of b that represents each digit
B= A(:);
plot(B);
lag=0; % iteration counter 
for digit=1:10 
C=B((n*lag/10)+1 :((n/10)*digit)); %length of each digit
D= (abs(fft(C-mean(C),100000))); %pad zeros 
E= D; %temp holder;
plot(D);
j=0;
[max_value_1, indexMax_1] = max(D);

%% Sift through max's to find f2
while (max_value_1 > 3000 || j==0)
    [max_value_1, indexMax_1] = max(D);
    if (indexMax_1 > 14754 && indexMax_1 < 14761) %ideal 14758.3
        frequency1= indexMax_1*fs/(length(D));
        j=1;    
    elseif ((indexMax_1 >16300 && indexMax_1 < 16312)) %ideal 16308.6
        frequency1= indexMax_1*fs/(length(D));
        j=1;
    elseif ((indexMax_1 > 18020 && indexMax_1 < 18035))%ideal 18029
        frequency1= indexMax_1*fs/(length(D));
        j=1;
    else
    D(indexMax_1)=0;
    max_value_1=0;
    [max_value_1, indexMax_1] = max(D);
    j=0;
   end 
end

%% sift through holder array for f1
for i= 12000: length(E)
    E(i)=0;
end
for i=1:8500
    E(i)= 0;
end
[max_value_2, indexMax_2] = max(E);
k=0;
while ( max_value_2 > 3000 || k== 0)
    [max_value_2, indexMax_2] = max(E);
    if (indexMax_2 < 8520 && indexMax_2 > 8490 )
        frequency2= indexMax_2*fs/(length(E));
        k=1;
    elseif (indexMax_2 > 9370 && indexMax_2 < 9420 )
        frequency2= indexMax_2*fs/(length(E));
        k=1;
    elseif (indexMax_2 > 10370 && indexMax_2 < 10430 )
        frequency2= indexMax_2*fs/(length(E));
        k=1;
    elseif (indexMax_2 > 11470 && indexMax_2 < 11520 )
        frequency2= indexMax_2*fs/(length(E));
        k=1;
    else 
    E(indexMax_2)=0;
    max_value_2=0;
    k=0;
    end
end 
%% check frequency values
if frequency1 > frequency2
    temp= frequency1;
    frequency1= frequency2;
    frequency2= temp;
end 
%% frequency1 tolerances
if (frequency1 > 670 && frequency1 < 720)
    frequency1= 697;
elseif (frequency1 > 720 && frequency1 < 800)
    frequency1= 770;
elseif (frequency1 > 805 && frequency1 < 895)
    frequency1= 852; 
elseif (frequency1 > 900 && frequency1 < 970)
    frequency1= 941;
end
%% frequency2 tolerances    
if (frequency2 > 1150 && frequency2 < 1240)
    frequency2= 1209;
elseif (frequency2 > 1290 && frequency2 < 1370)
    frequency2= 1336;
elseif (frequency2 > 1440 && frequency2 < 1500)
    frequency2= 1477; 
end

%% Figure out phone number
switch(frequency1)
    case{697}
        switch(frequency2)
            case{1209}
                key='1';
            case{1336}
                key='2';
            case{1477}
                key='3';
        end
     case{770}
        switch(frequency2)
            case{1209}
                key='4';
            case{1336}
                key='5';
            case{1477}
                key='6';
        end
      case{852}
        switch(frequency2)
            case{1209}
                key='7';
            case{1336}
                key='8';
            case{1477}
                key='9';
        end
       case{941}
        switch(frequency2)
            case{1209}
                key='*';
            case{1336}
                key='0';
            case{1477}
                key='#';
        end
              
end
PhoneNumber(digit)= key;  
lag= lag+1;
end
%% Output PhoneNumber
disp('Phone number is: ')
disp(PhoneNumber);
%% Recheck file
prompt= 'Enter a filename or say exit or q to quit program ';
filename= input(prompt, 's');
s1= 'exit';
s2= 'q';
tf1= strcmpi(s1,filename);
tf2= strcmpi(s2,filename);
end
