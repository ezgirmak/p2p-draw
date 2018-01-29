% Function to randomize the order of presented stimulus and save the random
% seed for the future use. Takes the size of stimulus set and the number of
% repetitions wanted as input and returns the permutated list with the seed
% used as the output
function [index cRng]= RandomizeOrder(stimSize, rep)
%save the current random generator
cRng = rng;
%create an array to index starting from 1 to the size of the stim array
index =  1:stimSize;
%replicate it by 1xrep 
index = repmat(index,1,rep);
tSize = length(index); %no of trials
index = index(randperm(tSize));
end