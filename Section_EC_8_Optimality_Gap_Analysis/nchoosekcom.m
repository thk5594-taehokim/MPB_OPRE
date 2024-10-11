function [C, D] = nchoosekcom (V, K)
%NCHOOSEKCOM Binomial coefficient or all combinations, and its complement
%   With one output argument, C = NCHOOSEKCOM (..) is the same as C =
%   NCHOOSEK(..).  For a vector V, C = NCHOOSEKCOM(V, K) returns a matrix
%   with all possible combinations of the elements of V, taken K at a time.
%   See NCHOOSEK for details.  
%
%   With two output arguments, [C, D] = NCHOOSEKCOM (V, K) also returns the
%   complementary combinations in D. C and D have the same number of rows:
%   when the j-th row of C contains a combination of K elements of V, then
%   the j-th row of D contains the other elements. In other words, [C(j,:)
%   D(j,:)] is the same as V, except for order.
%  
%   For a positive scalar N, [C D] = nchoosekcom(N, K) will return the
%   binomial coefficient (= N!/K!(N-K)!) in both C and D, since the number
%   of combinations of N things taken K at a time equals the number of
%   combinations of N things taken (N-K) at a time.
%
%   Example:
%     [C, D] = nchoosekcom(1:5, 2)
%        % C:     D:
%        % 1 2    3 4 5
%        % 1 3    2 4 5
%        % 1 4    2 3 5
%        % ..
%        % 3 4    1 2 5
%        % 3 5    1 2 4
%        % 4 5    1 2 3
%
%   See also PERMS, NCHOOSEK
%            PERMN, PERMSK, ALLCOMB (File Exchange)
% version 1.0 (apr 2019)
% (c) Jos van der Geest
% Matlab File Exchange Author ID: 10584
% email: samelinoa@gmail.com
% History:
% 1.0, created when addressing Matlab Answers #276055, added comments 
% nchoosek will do all the important error checking
C = nchoosek(V, K) ;
if nargout == 2
    % this function differs from NCHOOSEK when the complement is asked for
    if isscalar(V) && isnumeric(V) && isreal(V) && V==round(V) && V >= 0
        % V is a positive scalar N, for which
        % nchoosek(N, N-K) equals nchoosek(N, K), so: 
        D = C ;
    else   
        % get the remaining elements that are not in C, per row
        D = flipud(nchoosek(V, numel(V) - K)) ;
    end
end

