function [p,e,t] = bsp03b
p = [0     3     3     0;
     0     0     3     3];
t = [1     2;
     2     3;
     4     4];
e = [1     2     3     4;
     2     3     4     1;
     0     0     0     0;
     1     1     1     1;
     1     2     3     4];

p = p/3;