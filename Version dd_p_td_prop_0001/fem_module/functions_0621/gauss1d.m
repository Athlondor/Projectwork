function[xi, w8] = gauss1d(nqp,ndm)
if ndm == 2 
   if nqp > 3 
   disp('that does not work in this bad written function')
end
    if nqp == 1  
        xi = 0;
        w8 = 2; 
    end
    if nqp == 2 
        xi = [-1/sqrt(3);
              1/sqrt(3)];
        w8 = [1;
            1];
    end
   if nqp == 3 
       xi = [-sqrt(3/5);
            0;
            sqrt(3/5)];
      w8 = [5/9;
           8/9;
           5/9];
   end
   
else 
     disp('that does not work in this bad written function')
end
  
end
    