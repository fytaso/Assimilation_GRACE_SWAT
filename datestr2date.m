function [ year, day ] = datestr2date( datestr )
%DATESTR2DATE Summary of this function goes here
%   Detailed explanation goes here
    
    year = str2double(datestr(1:4));
    day = str2double(datestr(5:7));

end

