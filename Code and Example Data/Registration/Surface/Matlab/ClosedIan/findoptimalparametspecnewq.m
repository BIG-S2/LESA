function [f2new,A2new,A_tmp12new,A_tmp22new,A_tmp21,optdodeca,optrot]=findoptimalparamet(f1,f2,Theta,Phi,sc)

[n,t,d]=size(f2);
O=DodecaElements;

[Snorm1,A1,A_tmp11,A_tmp21] = area_surf_closed(f1);
% f1 = center_surface_closed(f1,A_tmp11,A1,Theta);
% f1 = scale_surf(f1,A1);
% [A1,A_tmp11,A_tmp21] = area_surf_closed(f1);
q1 = surface_to_q(Snorm1,A_tmp21);
[Snorm2,A2,A_tmp12,A_tmp22] = area_surf_closed(f2);
% f2 = center_surface_closed(f2,A_tmp12,A2,Theta);
% f2 = scale_surf(f2,A2);

% DisplaySurfaceClosed(f1,Theta,1);
% DisplaySurfaceClosed(f2,Theta,2);

for k=1:size(O,2)
    for i=1:n
        for j=1:n
            [x(1),x(2),x(3)]=spherical_to_cart(Theta(i,j),Phi(i,j),1);
            y=O{k}*x';
            [Thetan(i,j),Phin(i,j),tmp]=cartesian_to_sph(y(1),y(2),y(3));
            if (Phin(i,j)<0)
                Phin(i,j)=Phin(i,j)+2*pi;
            end
        end
    end
    Thetan=min(max(0,Thetan),pi);
    Phin=min(max(0,Phin),2*pi);
    gamnew{k}(:,:,1)=Thetan;
    gamnew{k}(:,:,2)=Phin;
    f2n{k}=Apply_Gamma_Surf_Closed(f2,Theta,Phi,gamnew{k});
    for i=1:n
        for j=1:n
            f2n{k}(i,j,:)=O{k}'*squeeze(f2n{k}(i,j,:));
        end
    end
    [Snorm2n,A2n,multfact2n,sqrtmultfact2n] = area_surf_closed(f2n{k});
    q2ntmp = surface_to_q(Snorm2n,sqrtmultfact2n);
    Ot = optimal_rot_surf_closed(q1,q2ntmp,Theta);
    f2n{k} = rotate3D(f2n{k},Ot);
    [Snorm2nn{k},A2nn{k},A_tmp12nn{k},A_tmp22nn{k}] = area_surf_closed(f2n{k});
%     f2n{k} = center_surface_closed(f2n{k},A_tmp12n,A2n,Theta);
%     f2n{k} = scale_surf(f2n{k},A2n);
    q2n = surface_to_q(Snorm2nn{k},A_tmp22nn{k});
%     distparam(k)=Calculate_Distance_Closed(f1,q2n,Theta);
    distparam(k)=Calculate_Distance_Closed(q1,q2n,Theta);
end

[tmp,idx]=min(distparam);
H=distparam(idx);
f2new=f2n{idx};
A2new=A2nn{idx};
A_tmp12new=A_tmp12nn{idx};
A_tmp22new=A_tmp22nn{idx};
optdodeca=gamnew{idx};
optrot=O{idx};
% DisplaySurfaceClosed(f2new,Theta,3);