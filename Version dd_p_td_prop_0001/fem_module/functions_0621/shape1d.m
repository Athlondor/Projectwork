function[N, gamma] = shape1d(xi, nen, ndm)
if ndm == 2


    N = [0.5*(-xi+1);
         0.5*(xi+1)];
   
    gamma = [-0.5;
             0.5];
            
    

end
        