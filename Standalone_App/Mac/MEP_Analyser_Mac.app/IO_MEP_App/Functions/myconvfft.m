function c = myconvfft(a, b, shape)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		myconvfft
%
%		Parameters
%	
%		c = myconvfft(a,b);
%		c = myconvfft(a,b,shape);
%
%		a		first vector
%		b		second vector
%		shape	'full'
%				'same'
%				'valid'
%
%       attention: is slower than myfftn!!

if nargin<3 || isempty(shape)
    shape = 'full';
end



c = ifft( fft(a,length(a)+length(b)-1) .* fft(b,length(a)+length(b)-1) );


switch lower(shape)
    case 'full'
		% nothing: is already as it should be
    case 'same'
        c = c(ceil((length(a)-1)/2)+(1:length(b)));
    case 'valid'
        ifun = @(m,n) n:m;
		c = c( min(length(a),length(b)):max(length(a),length(b)) );
    otherwise
        error('shape "%s" not expected', shape);
end
