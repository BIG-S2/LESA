function [F2n,F1,F2nb,F2nb1,H,Hstart,gamcum] = Compute_Elastic_Geod_Surf_Closednewq(F1,F2,N,Theta,Phi,Psi,b,gridrotval,eps)
close all;

tic;

global ShowFigures

% Scale=0;
ShowFigures=0;

% Resample surfaces with appropriate number of points (usually 70 is a good
% grid size)
F1=MakeClosedGrid(F1,N);
F2=MakeClosedGrid(F2,N);
[n,t,d] = size(F1);

gamid = MakeDiffeo_Closed(0,n,0,b);

%scale and center both surfaces
[~,A1,multfact1,sqrtmultfact1] = area_surf_closed(F1);
[~,A2,multfact2,sqrtmultfact2] = area_surf_closed(F2);
F1 = scale_surf(F1,A1);
F2 = scale_surf(F2,A2);
[~,A1,multfact1,sqrtmultfact1] = area_surf_closed(F1);
[~,A2,multfact2,sqrtmultfact2] = area_surf_closed(F2);
F1 = center_surface_closed(F1,multfact1,A1,Theta);
F2n = center_surface_closed(F2,multfact2,A2,Theta); 
[Snorm1,A1,multfact1,sqrtmultfact1] = area_surf_closed(F1);
[Snorm2n,A2n,multfact2n,sqrtmultfact2n] = area_surf_closed(F2n);
F2nb=F2n;

if (ShowFigures==1)
    DisplaySurfaceMatchClosed(F1,F1,1);
    title('First Surface')     
    DisplaySurfaceMatchClosed(F1,F2n,97);
    title('Second Surface')  
end
q1 = surface_to_q(Snorm1,sqrtmultfact1);
q2n = surface_to_q(Snorm2n,sqrtmultfact2n);
Hstart=Calculate_Distance_Closed(q1,q2n,Theta);

if gridrotval==1
    [f2new]=findoptimalparametspecnewq(F1,F2n,Theta,Phi,0);
    f1=F1;
    A_tmp21=sqrtmultfact1;
    [~,Ap,multfactp,~] = area_surf_closed(f2new);
    f2new = center_surface_closed(f2new,multfactp,Ap,Theta);
    f2new = scale_surf(f2new,Ap);
else
f1=F1;
A_tmp21=sqrtmultfact1;
f2new=F2n;
end

F2nb1=f2new;
fdisp=f2new;

if (ShowFigures==1)
    DisplaySurfaceMatchClosed(F1,f2new,98);
    %title('')      %Add Title CS
end

if ShowFigures == 1
    figure(100);
    winsize = get(figure(100),'Position');
    winsize(1:2) = [0 0];
    numframes=100;
    A=moviein(numframes,figure(100),winsize);
    set(figure(100),'NextPlot','replacechildren');
    DisplaySurfaceMatchClosed(F1,f2new,100);
    A(:,1)=getframe(figure(100),winsize);
else
    A = 0;
    winsize=[0,0,100,100];
    numframes=100;
end
gamcum(:,:,1)=sin(Theta).*cos(Phi);
gamcum(:,:,2)=sin(Theta).*sin(Phi);
gamcum(:,:,3)=cos(Theta);

%optimal rotation
[Snorm2n,A2n,multfact2n,sqrtmultfact2n] = area_surf_closed(f2new);
q2n = surface_to_q(Snorm2n,sqrtmultfact2n);
Ot = optimal_rot_surf_closed(q1,q2n,Theta);
f2new = rotate3D(f2new,Ot);
[Snorm2n,A2n,multfact2n,A_tmp22new] = area_surf_closed(f2new);
run=1;
epsmin=1e-5;
%optimal re-parameterization
while run==1
    run=0;
    try
[F2n,H1,gamcum,iter1,A] = ReParamclosed(f1,f2new,Snorm1,Snorm2n,A_tmp21,A_tmp22new,b,gamcum,gamid,Theta,Phi,Psi,2,A,winsize,79,eps);
    catch
        if eps<epsmin
            fprintf('Giving Up')
%             gamcum=gamid;
            H1=Hstart;
            iter1=2;
        else
            eps=eps/2;
            run=1;
            fprintf('Trying Again eps = %g\n',eps);
        end
    end
end
[~,Ap,multfactp,~] = area_surf_closed(F2n);
F2n = center_surface_closed(F2n,multfactp,Ap,Theta);
F2n = scale_surf(F2n,Ap);
%optimal rotation
[Snorm2n,A2n,multfact2n,sqrtmultfact2n] = area_surf_closed(F2n);
q2n = surface_to_q(Snorm2n,sqrtmultfact2n);
Ot = optimal_rot_surf_closed(q1,q2n,Theta);
F2n = rotate3D(F2n,Ot);
[Snorm2n,A2n,multfact2n,sqrtmultfact2n] = area_surf_closed(F2n);
if ShowFigures == 1
    DisplaySurfaceMatchClosed(f1,F2n,100);
    A(:,iter1)=getframe(figure(100),winsize);
end
%optimal re-parameterization
run=1;
epsmin=1e-5;
while run==1
    run=0;
    try
[F2n,H2,gamcum,iter1,A] = ReParamclosed(f1,F2n,Snorm1,Snorm2n,sqrtmultfact1,sqrtmultfact2n,b,gamcum,gamid,Theta,Phi,Psi,iter1+1,A,winsize,75,eps);
    catch
        if eps<epsmin
            fprintf('Giving Up')
            H2=Hstart;
        else
            eps=eps/2;
            run=1;
            fprintf('Trying Again eps = %g\n',eps);
        end
    end
end
[~,Ap,multfactp,~] = area_surf_closed(F2n);
F2n = center_surface_closed(F2n,multfactp,Ap,Theta);
F2n = scale_surf(F2n,Ap);
%optimal rotation
[Snorm2n,A2n,multfact2n,sqrtmultfact2n] = area_surf_closed(F2n);
q2n = surface_to_q(Snorm2n,sqrtmultfact2n);
Ot = optimal_rot_surf_closed(q1,q2n,Theta);
F2n = rotate3D(F2n,Ot);
[Snorm2n,A2n,multfact2n,sqrtmultfact2n] = area_surf_closed(F2n);
if ShowFigures == 1    
    DisplaySurfaceMatchClosed(f1,F2n,100);
    A(:,iter1)=getframe(figure(100),winsize);
end
%optimal re-parameterization
run=1;
epsmin=1e-5;
while run==1
    run=0;
    try
[F2n,H3,gamcum,iter1,A] = ReParamclosed(f1,F2n,Snorm1,Snorm2n,sqrtmultfact1,sqrtmultfact2n,b,gamcum,gamid,Theta,Phi,Psi,iter1+1,A,winsize,1000,eps);
    catch
        if eps<epsmin
            fprintf('Giving Up')
            H3=Hstart;
        else
            eps=eps/2;
            run=1;
            fprintf('Trying Again eps = %g\n',eps);
        end
    end
end
[~,Ap,multfactp,~] = area_surf_closed(F2n);
F2n = center_surface_closed(F2n,multfactp,Ap,Theta);
F2n = scale_surf(F2n,Ap);
toc;

H=[Hstart,H1,H2,H3];
if (ShowFigures==1)
DisplaySurfaceClosed(gamcum,0,3);
figure(5); clf;
plot(H,'LineWidth',3);
set(gca,'FontSize',25);
DisplaySurfaceMatchClosed(F1,F2n,99);
end

H = min(H);
perchange=(Hstart-H)*100/Hstart
end