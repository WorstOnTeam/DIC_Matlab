function dic() 
	clear
	close all
	clc
	syms dx dy x0 y0 %P P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 
	current_folder=pwd;
	addpath(strcat(current_folder,'\readimxstuff'));

	% Declare the input info that defines what correlation is done
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	save_as='check_NRtracking4_stop_crit.mat';
	save_as='check_NRtracking4_stop_crit_stricter.mat';
	save_as='check_NRtracking4_stop_crit_stricter_alt_G.mat';
	save_as='check_LKsymbolic.mat';
	reusing_setup=0;
	inc=10;
	%define subset size
	subsize=41;
	stepsize=20;

	P = sym('P%d', [6,1])

	B=[(1+P(2)), P(3), P(1);
		P(5), (P(6)+1), P(4);
		0 0 1]
	X=[dx;dy;1];

	correlation_method='LK'

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%determine name of coefficients saving file based on file save name
	[~,name_short,~] = fileparts(save_as);
	% determing names of save files and create folder for processed data so that it is not saved within programs folder
	current_path=pwd;
	if ismac||isunix
		idcs   = strfind(current_path,'/');
 		newdir = current_path(1:idcs(end)-1);
 		if 7~=exist(strcat(newdir,'/DIC_Procdata'),'dir')
			mkdir(newdir,'DIC_Procdata');
 		end
 		if 7~=exist(strcat(newdir,strcat('/DIC_Procdata/',name_short)))
	 		mkdir(strcat(newdir,'/DIC_Procdata'),name_short)
	 	end
 		save_full=fullfile(newdir,'DIC_Procdata',name_short,save_as);
 		coef_save_name=fullfile(newdir,'DIC_Procdata',name_short,strcat(name_short,'_coefs.mat'));
 	elseif ispc
 		idcs   = strfind(current_path,'\');
 		newdir = current_path(1:idcs(end)-1);
 		if 7~=exist(strcat(newdir,'\DIC_Procdata'),'dir')
			mkdir(newdir,'DIC_Procdata');
 		end
 		if 7~=exist(strcat(newdir,strcat('\DIC_Procdata\',name_short)))
	 		mkdir(strcat(newdir,'\DIC_Procdata'),name_short)
	 	end
 		save_full=fullfile(newdir,'DIC_Procdata',name_short,save_as);
 		coef_save_name=fullfile(newdir,'DIC_Procdata',name_short,strcat(name_short,'_coefs.mat'));
 	end
 	[new_folder,~,~]=fileparts(save_full);
 	addpath(new_folder);

 	% check if the images have been partially correlated already
	if exist(save_full,'file')
		load(save_full);
		% Proc.correlated_to=1;
		subpos=Proc.subpos;
		% guess_store=Proc.guess;
		guess_store=[0 0];
		guess=[guess_store(1),0,0,guess_store(2),0,0];
		starting_subset=Proc.starting_subset;
		process_order=Proc.process_order;
		valid_subsets=Proc.valid_subsets;
		getIndex=Proc.getIndex;
		FileName=Proc.FileName;
		PathName=Proc.PathName;
		% Proc.stepsize=stepsize;
		stepsize=Proc.stepsize;
		% PathName='G:\Work\Richard data\20160909_Richard_Huchzermeyer_CTC_03\CTC_03\';
		inc=Proc.inc;
		% Proc.inc=inc;
		% X=Proc.WarpVec;
		% B=Proc.Warp;
		stepsize=Proc.stepsize;
		subsize=Proc.subsize;
		current_image=Proc.correlated_to;
		% clear Proc.im
		% Proc.stepsize=stepsize;
		% Proc.subsize=subsize;

		if current_image==1
			[process_order,getIndex]=correlationOrderUpdated(subpos,starting_subset,valid_subsets);
			Proc.process_order=process_order;
		end
	else 
		[FileName,PathName] = uigetfile('*.im7','Select the images','MultiSelect','on');
		Proc.FileName=FileName;
		Proc.PathName=PathName;
		Proc.inc=inc;
		Proc.stepsize=stepsize;
		Proc.subsize=subsize;
		Proc.Warp=B;
		Proc.WarpVec=X;
		symbolic_warp(B,X)
		for i=1:2
			% image_folder=strcat(PathName,FileName(i))
			image_folder = fullfile( PathName , FileName{i} );
			I{i}=readimx(image_folder);
		end
		F_in=im2double(I{1}.Frames{1,1}.Components{1,1}.Planes{1,1});
		mask=makeMask(F_in);
		% figure
		% imagesc(F_in)
		% polygon=impoly();
		% Proc.polygon=polygon;
		% mask=createMask(polygon);
		[subpos,mask_subsets,valid_subsets]=mask2subsets(mask,subsize,stepsize);
		Proc.subpos=subpos;
		Proc.mask_subsets=mask_subsets;
		Proc.valid_subsets=valid_subsets;
		[xguess,yguess,subx,suby]=seedPoints(PathName, FileName, subpos, mask_subsets,stepsize,subsize);

		xguess=0;
		yguess=0;

		Proc.guess=[xguess,yguess];
		guess_store=Proc.guess;
		guess=[guess_store(1),0,0,guess_store(2),0,0];
		starting_subset=whichSubpos(subpos,stepsize,subx,suby);
		Proc.starting_subset=starting_subset;
		[process_order,getIndex]=correlationOrderUpdated(subpos,starting_subset,valid_subsets);
		Proc.process_order=process_order;
		Proc.getIndex=getIndex;
		Proc.correlated_to=1;
		current_image=1;
		save(save_full,'Proc')
	end

	% if you want to use the data from an old correlation but save it as a separate file
	if reusing_setup==1
		save_as='check_NRtracking4_recorrrelation_func.mat';
		%determine name of coefficients saving file based on file save name
		[~,name_short,~] = fileparts(save_as);
		% determing names of save files and create folder for processed data so that it is not saved within programs folder
		current_path=pwd;
		if ismac||isunix
			idcs   = strfind(current_path,'/');
	 		newdir = current_path(1:idcs(end)-1);
	 		if 7~=exist(strcat(newdir,'/DIC_Procdata'),'dir')
				mkdir(newdir,'DIC_Procdata');
	 		end
	 		if 7~=exist(strcat(newdir,strcat('/DIC_Procdata/',name_short)))
		 		mkdir(strcat(newdir,'/DIC_Procdata'),name_short)
		 	end
	 		save_full=fullfile(newdir,'DIC_Procdata',name_short,save_as);
	 		coef_save_name=fullfile(newdir,'DIC_Procdata',name_short,strcat(name_short,'_coefs.mat'));
	 	elseif ispc
	 		idcs   = strfind(current_path,'\');
	 		newdir = current_path(1:idcs(end)-1);
	 		if 7~=exist(strcat(newdir,'\DIC_Procdata'),'dir')
				mkdir(newdir,'DIC_Procdata');
	 		end
	 		if 7~=exist(strcat(newdir,strcat('\DIC_Procdata\',name_short)))
		 		mkdir(strcat(newdir,'\DIC_Procdata'),name_short)
		 	end
	 		save_full=fullfile(newdir,'DIC_Procdata',name_short,save_as);
	 		coef_save_name=fullfile(newdir,'DIC_Procdata',name_short,strcat(name_short,'_coefs.mat'));
	 	end
	 	[new_folder,~,~]=fileparts(save_full);
	 	addpath(new_folder);
	 end
	

	image_folder = fullfile( PathName , FileName{1} );
	I{1}=readimx(image_folder);
	F_in=im2double(I{1}.Frames{1,1}.Components{1,1}.Planes{1,1});
    [r_F,c_F]=size(F_in);
 	image_count=max(size(FileName));
	
	elements=sum(sum(valid_subsets))
	size(process_order)
	process_order
	Pend=5+max(size(guess));
	process_order2=process_order(:,2:3);
	[hmm] = unique(process_order2, 'rows', 'first');
	size(hmm)

	% functions to create relevant functions for the correlation process
	fprintf('~ Creating necessary supporting functions...');
	if strcmp(correlation_method,'NR')==1
		[folder_check,name_short_check,~] = fileparts(save_full);
		name1=fullfile(folder_check,strcat(name_short_check,'_jac.m'));
		name2=fullfile(folder_check,strcat(name_short_check,'_hes.m'));
		name3=fullfile(folder_check,strcat(name_short_check,'_pos.m'));
		% if the supporting functions do not exist or if the warp function is different
		if (exist(name1, 'file')~=2)||(exist(name2, 'file')~=2)||((exist(name3, 'file')~=2))||(isequal(Proc.Warp,B)~=1)||(isequal(Proc.WarpVec,X)~=1) 
			NR_symbolic(B,X,save_full,P,2);
		end
	elseif strcmp(correlation_method,'LK')==1
		[folder_check,name_short_check,~] = fileparts(save_full);
		name1=fullfile(folder_check,'WarpFunc.m');
		name2=fullfile(folder_check,'dPFunc.m');
		name3=fullfile(folder_check,'WarpMat.m');
		name4=fullfile(folder_check,'Mat2Vec.m');
		LK_symbolic(B,X,save_full,P);
		% if the supporting functions do not exist or if the warp function is different
		if (isequal(Proc.Warp,B)~=1)||(isequal(Proc.WarpVec,X)~=1)||(exist(name1, 'file')~=2)||(exist(name2, 'file')~=2)||(exist(name3, 'file')~=2)||(exist(name1, 'file')~=2)
			LK_symbolic(B,X,save_full,P);
		end
	end
	fprintf(' Done\n');

	% Correlation process 
	for k=(current_image+inc):inc:image_count
		fprintf('image %d\n',k);
		tic
		Proc.im{k}.D=process_order;
		image_folder = fullfile( PathName , FileName{k} );
		I{3}=readimx(image_folder);
		G_in=im2double(I{3}.Frames{1,1}.Components{1,1}.Planes{1,1});

		% check if the method is newton-raphson and if so then interpolate image
		if strcmp(correlation_method,'NR')==1
			if exist(coef_save_name,'file')
				load(coef_save_name);
				if coef_var.im==k
					coef=coef_var.coef;
				else
					clear coef_var;
					coef=getBicubicValues(G_in);
					coefficient_time=toc
					coef_var.coef=coef;
					coef_var.im=k; 
					save(coef_save_name,'coef_var','-v7.3','-nocompression');
				end
			else
				coef=getBicubicValues(G_in);
				coefficient_time=toc
				coef_var.coef=coef;
				coef_var.im=k; 
				save(coef_save_name,'coef_var','-v7.3','-nocompression');
			end
		end
		
		if (k==(1+inc)) %if this is the first image to be correlated
			tic
			lb=[-5 -0.5 -0.5 -5 -0.5 -0.5];
			ub=[5 0.5 0.5 5 0.5 0.5];
			coef_shift(3)=5;
			[guess,funcval]=particleFirstGuess('undeformed image',F_in,'deformed image',G_in,'subset size',subsize,'stepsize',stepsize,'subset position',subpos{process_order(1,2),process_order(1,3)},'guess',guess,'coef',coef((subpos{process_order(1,2),process_order(1,3)}.coords(1)-stepsize*coef_shift(3)):(subpos{process_order(1,2),process_order(1,3)}.coords(3)+stepsize*coef_shift(3)),(subpos{process_order(1,2),process_order(1,3)}.coords(2)-stepsize*coef_shift(3)):(subpos{process_order(1,2),process_order(1,3)}.coords(4)+stepsize*coef_shift(3)),:),'coef_shift',[0 0 coef_shift(3)],'save_name',save_as,'algorithm',1,'lb',lb,'ub',ub)
			if strcmp(correlation_method,'NR')==1
				[PP(1,:),Corrr(1),iter(1)]=NRtracking4('undeformed image',F_in,'deformed image',G_in,'subset size',subsize,'stepsize',stepsize,'subset position',subpos{process_order(1,2),process_order(1,3)},'guess',guess,'coef',coef((subpos{process_order(1,2),process_order(1,3)}.coords(1)-stepsize):(subpos{process_order(1,2),process_order(1,3)}.coords(3)+stepsize),(subpos{process_order(1,2),process_order(1,3)}.coords(2)-stepsize):(subpos{process_order(1,2),process_order(1,3)}.coords(4)+stepsize),:),'coef_shift',[0 0 1],'save_name',save_as,'algorithm',1)
			elseif strcmp(correlation_method,'LK')==1
				[PP(1,:),Corrr(1)]=DICtracking2('undeformed image',F_in,'deformed image',G_in,'subset size',subsize,'subset position',subpos{process_order(1,2),process_order(1,3)},'guess',guess,'correlation',3);
			end
			toc
			for i=2:elements
				if strcmp(correlation_method,'NR')==1
					best_guess=bestGuess(Corrr,i-1);
					[PP(i,:),Corrr(i),iter(i)]=NRtracking4('undeformed image',F_in,'deformed image',G_in,'subset size',subsize,'stepsize',stepsize,'subset position',subpos{process_order(i,2),process_order(i,3)},'guess',PP(best_guess,:),'coef',coef((subpos{process_order(i,2),process_order(i,3)}.coords(1)-stepsize):(subpos{process_order(i,2),process_order(i,3)}.coords(3)+stepsize),(subpos{process_order(i,2),process_order(i,3)}.coords(2)-stepsize):(subpos{process_order(i,2),process_order(i,3)}.coords(4)+stepsize),:),'coef_shift',[0 0 1],'save_name',save_as,'algorithm',1)
				% 	% [PP(i,:),Corrr(i)]=NRtracking3('undeformed image',F_in,'deformed image',G_in,'subset size',subsize,'subset position',subpos{process_order(i,2),process_order(i,3)},'guess',PP(i-1,:),'coef',coef)
				elseif strcmp(correlation_method,'LK')==1
					[PP(i,:),Corrr(i)]=DICtracking2('undeformed image',F_in,'deformed image',G_in,'subset size',subsize,'subset position',subpos{process_order(i,2),process_order(i,3)},'guess',PP(i-1,:),'correlation',3);
				end
			end
			for j=1:elements
				Proc.im{k}.D(j,6:Pend)=PP(j,:);
				Proc.im{k}.D(j,Pend+1)=Corrr(j);
			end
		else
			clear PP;
			clear Corrr;
			clear iter;
			% parallel_pool=gcp;
			% ppm = ParforProgMon('Correlation progress', elements,1,500,200);
			if strcmp(correlation_method,'NR')==1
				parfor i=1:elements
					% shift the search area according to the previous displacement estimates
					Pshift=Proc.im{k-inc}.D(i,6:Pend);
					coef_shift=[floor(Pshift(4)), floor(Pshift(1))]; %shift of coefficients (first y then x)
					coef_shift(3)=3;
					% coofs=[(subpos{process_order(i,2),process_order(i,3)}.coords(1)-stepsize+coef_shift(1)):(subpos{process_order(i,2),process_order(i,3)}.coords(3)+stepsize+coef_shift(1)),(subpos{process_order(i,2),process_order(i,3)}.coords(2)-stepsize+coef_shift(2)):(subpos{process_order(i,2),process_order(i,3)}.coords(4)+stepsize+coef_shift(2))];
					% coef_pass=coef((subpos{process_order(i,2),process_order(i,3)}.coords(1)-stepsize):(subpos{process_order(i,2),process_order(i,3)}.coords(3)+stepsize),(subpos{process_order(i,2),process_order(i,3)}.coords(2)-stepsize):(subpos{process_order(i,2),process_order(i,3)}.coords(4)+stepsize),:);
					[PP(i,:),Corrr(i),iter(i)]=NRtracking4('undeformed image',F_in,'deformed image',G_in,'subset size',subsize,'stepsize',stepsize,'subset position',subpos{process_order(i,2),process_order(i,3)},'guess',Proc.im{k-inc}.D(i,6:Pend),'coef',coef((subpos{process_order(i,2),process_order(i,3)}.coords(1)-stepsize*coef_shift(3)+coef_shift(1)):(subpos{process_order(i,2),process_order(i,3)}.coords(3)+stepsize*coef_shift(3)+coef_shift(1)),(subpos{process_order(i,2),process_order(i,3)}.coords(2)-stepsize*coef_shift(3)+coef_shift(2)):(subpos{process_order(i,2),process_order(i,3)}.coords(4)+stepsize*coef_shift(3)+coef_shift(2)),:),'coef_shift',coef_shift,'save_name',save_as,'algorithm',1)
					% ppm.increment();
				end
				PP
				Corrr
				iter
				outliers=isoutlier(Corrr,'median')
				good=ones(size(Corrr));
				good=good-outliers;
				while sum(outliers)>0
					[correlation_correction,check_recorrelation]=recorrelationOrder(good,outliers,PP,Corrr)
					for i=1:sum(check_recorrelation)
						% shift the search area according to the previous displacement estimates
						Pshift=Proc.im{k-inc}.D(correlation_correction(i,2),6:Pend);
						coef_shift=[floor(Pshift(4)), floor(Pshift(1))]; %shift of coefficients (first y then x)
						coef_shift(3)=3;
						% coofs=[(subpos{process_order(i,2),process_order(i,3)}.coords(1)-stepsize+coef_shift(1)):(subpos{process_order(i,2),process_order(i,3)}.coords(3)+stepsize+coef_shift(1)),(subpos{process_order(i,2),process_order(i,3)}.coords(2)-stepsize+coef_shift(2)):(subpos{process_order(i,2),process_order(i,3)}.coords(4)+stepsize+coef_shift(2))];
						% coef_pass=coef((subpos{process_order(i,2),process_order(i,3)}.coords(1)-stepsize):(subpos{process_order(i,2),process_order(i,3)}.coords(3)+stepsize),(subpos{process_order(i,2),process_order(i,3)}.coords(2)-stepsize):(subpos{process_order(i,2),process_order(i,3)}.coords(4)+stepsize),:);
						[PP(correlation_correction(i,1),:),Corrr(correlation_correction(i,1)),iter(correlation_correction(i,1))]=NRtracking4('undeformed image',F_in,'deformed image',G_in,'subset size',subsize,'stepsize',stepsize,'subset position',subpos{process_order(correlation_correction(i,1),2),process_order(correlation_correction(i,1),3)},'guess',PP(correlation_correction(i,2),6:Pend),'coef',coef((subpos{process_order(correlation_correction(i,1),2),process_order(correlation_correction(i,1),3)}.coords(1)-stepsize*coef_shift(3)+coef_shift(1)):(subpos{process_order(correlation_correction(i,1),2),process_order(correlation_correction(i,1),3)}.coords(3)+stepsize*coef_shift(3)+coef_shift(1)),(subpos{process_order(correlation_correction(i,1),2),process_order(correlation_correction(i,1),3)}.coords(2)-stepsize*coef_shift(3)+coef_shift(2)):(subpos{process_order(correlation_correction(i,1),2),process_order(correlation_correction(i,1),3)}.coords(4)+stepsize*coef_shift(3)+coef_shift(2)),:),'coef_shift',coef_shift,'save_name',save_as,'algorithm',1);
						% ppm.increment();
					end
					Corrr
					outliers=isoutlier(Corrr,'median')

					good=ones(size(Corrr));
					good=good-outliers;
				end

				% [val,minn]=min(Corrr);
				% for i=1:elements
				% 	if outliers(i)==1
				% 		% shift the search area according to the previous displacement estimates
				% 		Pshift=PP(minn,:);
				% 		coef_shift=[floor(Pshift(4)), floor(Pshift(1))]; %shift of coefficients (first y then x)
				% 		coef_shift(3)=3;
				% 		% coofs=[(subpos{process_order(i,2),process_order(i,3)}.coords(1)-stepsize+coef_shift(1)):(subpos{process_order(i,2),process_order(i,3)}.coords(3)+stepsize+coef_shift(1)),(subpos{process_order(i,2),process_order(i,3)}.coords(2)-stepsize+coef_shift(2)):(subpos{process_order(i,2),process_order(i,3)}.coords(4)+stepsize+coef_shift(2))];
				% 		% coef_pass=coef((subpos{process_order(i,2),process_order(i,3)}.coords(1)-stepsize):(subpos{process_order(i,2),process_order(i,3)}.coords(3)+stepsize),(subpos{process_order(i,2),process_order(i,3)}.coords(2)-stepsize):(subpos{process_order(i,2),process_order(i,3)}.coords(4)+stepsize),:);
				% 		[PP(i,:),Corrr(i),iter(i)]=NRtracking4('undeformed image',F_in,'deformed image',G_in,'subset size',subsize,'stepsize',stepsize,'subset position',subpos{process_order(i,2),process_order(i,3)},'guess',Pshift,'coef',coef((subpos{process_order(i,2),process_order(i,3)}.coords(1)-stepsize*coef_shift(3)+coef_shift(1)):(subpos{process_order(i,2),process_order(i,3)}.coords(3)+stepsize*coef_shift(3)+coef_shift(1)),(subpos{process_order(i,2),process_order(i,3)}.coords(2)-stepsize*coef_shift(3)+coef_shift(2)):(subpos{process_order(i,2),process_order(i,3)}.coords(4)+stepsize*coef_shift(3)+coef_shift(2)),:),'coef_shift',coef_shift,'save_name',save_as,'algorithm',1);
				% 		% ppm.increment();
				% 	end
				% end


				% indexing=1:1:max(size(Corrr));
				% count=0;
				% for i=1:elements
				% 	if isoutlier(i)==1
				% 		count=count+1;
				% 		indexes{count}=i;
				% 	end
				% end
				% % indexes=indexing(outliers);
				% % [out,minindex]=testOutlier(Corrr)
				% Pshift=PP(minn,:);
				% parfor i=1:count%max(size(indexes))
				% 		% shift the search area according to the previous displacement estimates
						
				% 		coef_shift=[floor(Pshift(4)), floor(Pshift(1))]; %shift of coefficients (first y then x)
				% 		coef_shift(3)=3;
				% 		% coofs=[(subpos{process_order(i,2),process_order(i,3)}.coords(1)-stepsize+coef_shift(1)):(subpos{process_order(i,2),process_order(i,3)}.coords(3)+stepsize+coef_shift(1)),(subpos{process_order(i,2),process_order(i,3)}.coords(2)-stepsize+coef_shift(2)):(subpos{process_order(i,2),process_order(i,3)}.coords(4)+stepsize+coef_shift(2))];
				% 		% coef_pass=coef((subpos{process_order(i,2),process_order(i,3)}.coords(1)-stepsize):(subpos{process_order(i,2),process_order(i,3)}.coords(3)+stepsize),(subpos{process_order(i,2),process_order(i,3)}.coords(2)-stepsize):(subpos{process_order(i,2),process_order(i,3)}.coords(4)+stepsize),:);
				% 		[PP(indexes{i},:),Corrr(indexes{i}),iter(indexes{i})]=NRtracking4('undeformed image',F_in,'deformed image',G_in,'subset size',subsize,'stepsize',stepsize,'subset position',subpos{process_order(indexes{i},2),process_order(indexes{i},3)},'guess',Pshift,'coef',coef((subpos{process_order(indexes{i},2),process_order(indexes{i},3)}.coords(1)-stepsize*coef_shift(3)+coef_shift(1)):(subpos{process_order(indexes{i},2),process_order(indexes{i},3)}.coords(3)+stepsize*coef_shift(3)+coef_shift(1)),(subpos{process_order(indexes{i},2),process_order(indexes{i},3)}.coords(2)-stepsize*coef_shift(3)+coef_shift(2)):(subpos{process_order(indexes{i},2),process_order(indexes{i},3)}.coords(4)+stepsize*coef_shift(3)+coef_shift(2)),:),'coef_shift',coef_shift,'save_name',save_as,'algorithm',1);
				% 		% ppm.increment();
				% end
				
				PP
				Corrr
				iter
				clear outliers

			elseif strcmp(correlation_method,'LK')==1
				parfor i=1:elements
					[PP(i,:),Corrr(i)]=DICtracking2('undeformed image',F_in,'deformed image',G_in,'subset size',subsize,'subset position',subpos{process_order(i,2),process_order(i,3)},'guess',Proc.im{k-inc}.D(i,6:11),'correlation',3);
					% ppm.increment();
				end
			end

			for j=1:elements
				Proc.im{k}.D(j,6:Pend)=PP(j,:);
				Proc.im{k}.D(j,Pend+1)=Corrr(j);
			end
		end
		total_time=toc
		Proc.correlated_to=k;
		% clear ppm;
		save(save_full,'Proc');
	end
end

function out=bestGuess(Cor,n)
	if n>2
		for i=n:-1:2
			if (Cor(i)<0.05)
				out=i;
				break;
			end
		end
		if ~exist('out','var')
			out=n;
			fprintf('The guess used is not ideal\n');
		end
	else
		out=n;
	end
end

%function to determine outliers in correlation value
function [out,minindex]=testOutlier(Cor)
	[minval,minindex]=min(Cor);
	for i=1:max(size(Cor))
		if Cor(i)>4*minval
			out(i)=1;
		else
			out(i)=0;
		end
			
	end
end

function out=findNearestNeighbour(D,a,b,Cor)
	% function to find the nearest neighbour subset that has the lowest correlation value
	count=1;
	for i=-1:1:1
		for j=-1:1:1
			if (i==0)&&(j==0)
				%skip this since it gives the point under investigation (a,b)
			else
				row(count,:)=[(a+i), (b+j)];
				count=count+1;
			end
		end
	end

	for i=1:8
		[tf, index]=ismember(D(:,2:3),row(i,:),'rows');
		position(i)=find(index, 1, 'first');
		Cor_compare(i)=Cor(position(i));
	end
	[val,minimum]=min(Cor_compare);
	out=position(minimum);
end

function [out,check]=recorrelationOrder(good,bad,P,Cor)
	% function to determine which subsets to correlate based on which are good and which are bad
	% only correlates bad ones that are less than 2 subsets in distance from one another
	good_ind=find(good);
	bad_ind=find(bad);
	% size(P)
	% determine the distance between the good and bad subsets
	for i=1:max(size(good_ind))
		for j=1:max(size(bad_ind))
			ydist(i,j)=P(bad_ind(j),2)-P(good_ind(i),2);
			xdist(i,j)=P(bad_ind(j),3)-P(good_ind(i),3);
		end
	end
	distances=(xdist.^2+ydist.^2).^(1/2);
	% find the closest good subset for each bad subset 
	for i=1:max(size(bad_ind))
		[val,minimum]=min(distances(:,i));
		if val<2
			check(i)=1;
			minimums{i}.m=find(distances(:,i) == min(distances(:,i))); %find all minimum positions
		else
			check(i)=0;
		end
	end
	% determine best nearest subset based on correlation value
	count=1;
	for i=1:max(size(bad_ind))
		if check(i)==1
			Cor_compare=Cor(minimums{i}.m);
			[val,mins]=min(Cor_compare);
			guess_index(i)=minimums{i}.m(mins);
			out(count,:)=[bad_ind(i),guess_index(i)];
			count=count+1;
		else
			guess_index(i)=0;
		end
	end
end