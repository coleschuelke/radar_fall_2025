function [data] = load_data(file_params)
%LOAD_DATA load SAR data from filename and formatting arguments
%   Returns complex matrix with range in the rows
    % Open the file based on line length
    fid = fopen(file_params.filename);
    data = fread(fid, [file_params.row_len, inf], file_params.encoding);
    
    % Transpose to range in rows
    data = data.';

    % Remove the header and debias
    data(:, 1:file_params.header_len) = [];
    I = data(:, 1:2:end) - file_params.bias;
    Q = data(:, 2:2:end) - file_params.bias;
    data = I + 1i * Q;
end
