function [Theta,Phi,Psi,b] = spherharmbasis(l,n)

n=n-1;

theta = pi*[.01:n+1-.01]/(n+.02);
phi = 2*pi*[0:n]/n;
Theta = repmat(theta,n+1,1);
Phi = repmat(phi',1,n+1);

[Psi,b] = formbasiselements(n,Theta,Phi);

% [Theta,Phi,Psi1] = spherharm(l,n);

[n,t,d]=size(Psi);
n=n-1;

dphi=(2*pi)/(n);
dtheta=(n*pi+pi-.02*pi)/(n^2-n);
 
for j=1:d
    lenpsi(j)=sum(sum(squeeze(Psi(:,:,j)).*squeeze(Psi(:,:,j)).*sin(Theta)))*(dphi*dtheta);
    Psi(:,:,j)=Psi(:,:,j)/sqrt(lenpsi(j));
end

for i=1:d
    for j=1:d
        R(i,j)=sum(sum(squeeze(Psi(:,:,i)).*squeeze(Psi(:,:,j)).*sin(Theta)))*(dphi*dtheta);
    end
end

% for i=1:16
%     for j=1:2
%         mn=(b(1,:,j,i)+b(end,:,j,i))./2;
%         b(1,:,j,i)=mn;
%         b(end,:,j,i)=mn;
%     end
% end

% [ph(1),th(1),r]=cart2sph(.01,.01,1);
% th(1)=pi/2-th(1);
% % [ph(2),th(2),r]=cart2sph(0,.01,1);
% % th(2)=pi/2-th(2);
% [ph(2),th(2),r]=cart2sph(.01,.01,-1);
% th(2)=pi/2-th(2);
% % [ph(4),th(4),r]=cart2sph(0,.01,-1);
% % th(4)=pi/2-th(4);
% [ph(5),th(5),r]=cart2sph(0,0,1);
% th(5)=pi/2-th(5);
% % ph(6)=ph(5);
% % th(6)=th(5);
% [ph(6),th(6),r]=cart2sph(0,0,-1);
% th(6)=pi/2-th(6);
% % ph(8)=ph(7);
% % th(8)=th(7);
% % ph=zeros(1,8);
% 
% keyboard;
% 
% for i=1:8
%     for k=1:2
%         tmp=interp2(Theta,Phi,Psi(:,:,i),th(k),ph(k),'spline');
%         tmp1=interp2(Theta,Phi,Psi(:,:,i),th(k+4),ph(k+4),'spline');
%         val(k)=(tmp-tmp1)/.01;
%         keyboard;
%     end
%     b(:,1,j,i)=repmat(val(1),n,1);
% %     b(:,1,j,i+16)=repmat(val(2),n,1);
%     b(:,end,j,i)=repmat(val(2),n,1);
% %     b(:,end,j,i+16)=repmat(val(4),n,1);
% end

% keyboard;

% for j=1:d
%     [dpsidtheta(:,:,j),dpsidphi(:,:,j)] = gradient(Psi(:,:,j),dtheta,dphi);
%     b1(:,:,1,j) = dpsidtheta(:,:,j);
%     for i=1:n
%         for k=1:n
%             if (sin(Theta(i,k))<0.00001)
%                 b1(i,k,2,j) = dpsidphi(i,k,j)./.01;
%             else
%                 b1(i,k,2,j) = dpsidphi(i,k,j)./sin(Theta(i,k));
%             end
%         end
%     end
% end

% k=size(b,4);
% 
% for j=(k+1):(2*k)
%     b(:,:,1,j) = b(:,:,2,j-k);
%     b(:,:,2,j) = -b(:,:,1,j-k);
% end
% 
% for i=1:16
%     for j=1:2
%         mn=(b(1,:,j,i)+b(end,:,j,i))./2;
%         b(1,:,j,i)=mn;
%         b(end,:,j,i)=mn;
%         b(:,1,j,i) = repmat(mean(b(:,1,j,i)),n,1);
%         b(:,end,j,i) = repmat(mean(b(:,end,j,i)),n,1);
%     a1 = mean(b(:,1,j,i));
%     a2 = mean(b(:,end,j,i));
%     if (a1>=0)
%         b(:,1,j,i)=repmat(max(b(:,1,j,i)),n,1);
%     else
%         b(:,1,j,i)=repmat(min(b(:,1,j,i)),n,1);
%     end
%     if (a2>=0)
%         b(:,end,j,i)=repmat(max(b(:,end,j,i)),n,1);
%     else
%         b(:,end,j,i)=repmat(min(b(:,end,j,i)),n,1);
%     end
%     end
% end

[a1,a2,a3,a4] = size(b);

for j=1:a4
    blen(j) = vfinnerprod(b(:,:,:,j),b(:,:,:,j),Theta);
    b(:,:,:,j) = b(:,:,:,j)/sqrt(blen(j));
end

for i=1:a4
    for j=1:a4
        Q(i,j)=vfinnerprod(b(:,:,:,i),b(:,:,:,j),Theta);
    end
end
% [X,Y,Z]=sphere(30,30);
% for j=1:16
% % close all;
% vx=-b(:,:,1,j).*sin(Theta);
% vy=b(:,:,1,j).*cos(Theta).*sin(Phi)+b(:,:,2,j).*sin(Theta).*cos(Phi);
% vz=-b(:,:,1,j).*cos(Theta).*sin(Phi)-b(:,:,2,j).*sin(Theta).*sin(Phi);
% % % vx=-sin(Theta);
% % % vy=cos(Theta).*sin(Phi)+sin(Theta).*cos(Phi);
% % % vz=-cos(Theta).*sin(Phi)-sin(Theta).*sin(Phi);
% % surf(.99.*X,.99.*Y,.99.*Z);
% % hold on
% % shading flat;
% % colormap([.9 .9 .9]);
% quiver3(cos(Theta),sin(Theta).*sin(Phi),sin(Theta).*cos(Phi),vx,vy,vz,'LineWidth',2);
% axis equal;
% axis off;
% % grid off;
% pause;
% end
% keyboard;