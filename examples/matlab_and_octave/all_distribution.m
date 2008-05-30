% Explicit examples on how to use distributions

leng=50;
rep=5;
weight=1;
order=3;
gap=0;
num=12;
len=23;
reverse='n'; % bit silly to not use boolean, set 'r' to yield true

addpath('tools');
fm_train_dna=load_matrix('../data/fm_train_dna.dat');


% Histogram
disp('Histogram');

%sg('new_distribution', 'HISTOGRAM');
sg('add_preproc', 'SORTWORDSTRING');

sg('set_features', 'TRAIN', fm_train_dna, 'DNA');
sg('convert', 'TRAIN', 'STRING', 'CHAR', 'STRING', 'WORD', order, order-1, gap, reverse);
sg('attach_preproc', 'TRAIN');

%	sg('train_distribution');
%	histo=sg('get_histogram');

%	num_param=sg('get_histogram_num_model_parameters');
%	for i = 1:num,
%		for j = 1:num_param,
%			sg(sprintf('get_log_derivative %d %d', j, i));
%		end
%	end

%	sg('get_log_likelihood');
%	sg('get_log_likelihood_sample');

% LinearHMM
disp('LinearHMM');

%sg('new_distribution', 'LinearHMM');
sg('add_preproc', 'SORTWORDSTRING');

sg('set_features', 'TRAIN', fm_train_dna, 'DNA');
sg('convert', 'TRAIN', 'STRING', 'CHAR', 'STRING', 'WORD', order, order-1, gap, reverse);
sg('attach_preproc', 'TRAIN');

%	sg('train_distribution');
%	histo=sg('get_histogram');

%	num_param=sg('get_histogram_num_model_parameters');
%	for i = 1:num,
%		for j = 1:num_param,
%			sg(sprintf('get_log_derivative %d %d', j, i));
%		end
%	end

%	sg('get_log_likelihood');
%	sg('get_log_likelihood_sample');

% HMM
disp('HMM');

N=3;
M=6;

% generate a sequence with characters 1-6 drawn from 3 loaded cubes
for i = 1:3,
    a{i}= [ ones(1,ceil(leng*rand)) 2*ones(1,ceil(leng*rand)) 3*ones(1,ceil(leng*rand)) 4*ones(1,ceil(leng*rand)) 5*ones(1,ceil(leng*rand)) 6*ones(1,ceil(leng*rand)) ];
    a{i}= a{i}(randperm(length(a{i})));
end

s=[];
for i = 1:size(a,2),
    s= [ s i*ones(1,ceil(rep*rand)) ];
end
s=s(randperm(length(s)));
sequence={''};
for i = 1:length(s),
    f(i)=ceil(((1-weight)*rand+weight)*length(a{s(i)}));
    t=randperm(length(a{s(i)}));
    r=a{s(i)}(t(1:f(i)));
    sequence{1}=[sequence{1} char(r+'0')];
end


sg('new_hmm', N, M);
sg('set_features','TRAIN', sequence, 'CUBE');
sg('convert', 'TRAIN', 'STRING', 'CHAR', 'STRING', 'WORD', 1);
sg('bw');
[p, q, a, b]=sg('get_hmm');

sg('new_hmm', N, M);
sg('set_hmm', p, q, a, b);
likelihood=sg('hmm_likelihood');


