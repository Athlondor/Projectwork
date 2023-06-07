function [Ke,finte,elem] =  element_routine(xe,Ke,finte,A_e,ue_vec,nqp,elem,e,dt,mat_flag)
l0 = sqrt((xe(1,2)-xe(1,1))^2+(xe(2,2)-xe(2,1))^2);
    cosphi = (xe(1,2)-xe(1,1))/l0;
    sinphi = (xe(2,2)-xe(2,1))/l0;
    Ge = [cosphi sinphi 0 0;
          0 0 cosphi sinphi];
      
    %displacements of current element 
    %displacements along the truss axis
	ue_loc = Ge*ue_vec;
    ndm = 2;
    nen = 2;
    
for q = 1:nqp  
    %get gamma and invJq from subroutines
    [xi,w8] = gauss1d(nqp,ndm);
    [N,gamma] = shape1d(xi(q,:),nen,ndm);
    [detJq,invJq] = jacobian1d(xe,gamma,nen,ndm);
    G = gamma*invJq;
    eps = ue_loc'*G;        %displacement gradient in current quad.point
    elem(e).eps(q) = eps;
    %Stress in current quadrature point: 1d Hooke's law
    %[sig,elem(e).ivar_np1(q),E_t] = mat_visc(eps,elem(e).ivar_n(q),dt);
   % [sig,elem(e).ivar_np1(q),E_t] = mat_linEl(eps,elem(e).ivar_n(q),dt);
    switch mat_flag
    case 1 % linear plasticity with isotropic hardening
        [sig,elem(e).ivar_np1(q,:),E_t] = mat_isotropic_hardening(eps,elem(e).ivar_n(q,:),dt);
%             [stress,sdvup] = linear_plasti_mex(sdv,epsilon,matparam);
    case 2 % Your material model here
        [sig,elem(e).ivar_np1(q,:),E_t] = mixed_linear_plasti(eps,elem(e).ivar_n(q,:),dt);

    end
       
    Ke = Ke + (gamma(1)*Ge(1,:)+gamma(2)*Ge(2,:))'*E_t*A_e*(gamma(1)*Ge(1,:)+gamma(2)*Ge(2,:))*invJq*w8(q);
    finte = finte + (gamma(1)*Ge(1,:)+gamma(2)*Ge(2,:))'*sig*A_e*w8(q);
    elem(e).sig(q) = sig;
end 
 end