function [data, data_re, data_im] = make_chirp(samples,tau,fs,chirp_slope, varargin)
    %MAKE_CHIRP Make a padded chirp signal

    start_index = 1;

    %--- loading any optional arguments
    while ~isempty(varargin)
        switch lower(varargin{1}) % switch to lowercase only
            case 'startindex'
                  start_index = varargin{2};
            otherwise
                  error(['Unexpected option: ' varargin{1}])
        end
        varargin(1:2) = [];
    end
    
    
    
    % Definitions
    dt = 1/fs;
    t = -tau/2:dt:tau/2;
    
    % Init the data vector
    data = zeros(1, samples);
    % Make the signal 
    signal = exp(1i*pi*chirp_slope.*t.^2);
    % Insert signal into pad vector
    data(start_index:(start_index+length(signal)-1)) = signal;
    % Define optional outputs
    if nargout > 2
        data_re = (data + conj(data))/2;
        data_im = (data - conj(data))/2i;
    end

end