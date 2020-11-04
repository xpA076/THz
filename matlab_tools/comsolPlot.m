[d,t]=comsol2data;
figure;
plot(d(:,1),abs(d(:,2:size(d,2))),'LineWidth',2);
set(gca,'FontSize',16);
ylim([0 1])
legend(t(2:length(t)));